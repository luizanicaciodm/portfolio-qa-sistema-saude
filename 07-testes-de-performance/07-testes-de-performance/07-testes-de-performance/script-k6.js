// Script de Performance — k6
// Cenário: até 1000 exclusões simultâneas de beneficiários
// Portfólio QA — Luiza Nicácio
//
// CORREÇÃO: a versão anterior enviava o MESMO cpf para todas as
// requisições. Como a exclusão altera o status do beneficiário,
// a partir da segunda requisição bem-sucedida o mesmo CPF passaria
// a retornar erro (já excluído), distorcendo a taxa de erro do teste.
// Agora cada iteração usa um CPF distinto de uma massa de dados
// dedicada para performance, evitando contenção e resultados falsos.

import http from 'k6/http';
import { check, sleep } from 'k6';
import { SharedArray } from 'k6/data';

export const options = {
  stages: [
    { duration: '1m', target: 100  },  // Ramp-up gradual
    { duration: '3m', target: 1000 },  // Pico de carga
    { duration: '1m', target: 0   },  // Ramp-down
  ],
  thresholds: {
    http_req_duration: ['p(95)<3000'],  // 95% abaixo de 3s
    http_req_failed:   ['rate<0.01'],   // < 1% de erros
  },
};

// Massa de dados dedicada para o teste de performance: 1000 CPFs
// sintéticos pré-cadastrados em homologação especificamente para
// este cenário, isolados dos dados usados em testes funcionais.
const cpfsDeCarga = new SharedArray('cpfs de performance', function () {
  const lista = [];
  for (let i = 0; i < 1000; i++) {
    lista.push(`999.000.${String(i).padStart(3, '0')}-00`);
  }
  return lista;
});

export default function () {
  // Cada Virtual User (VU) consome um CPF diferente da massa de dados,
  // evitando que duas requisições simultâneas tentem excluir o mesmo
  // beneficiário (o que geraria erro 409/404 e poluiria as métricas).
  const cpf = cpfsDeCarga[(__VU - 1) % cpfsDeCarga.length];

  const payload = JSON.stringify({
    cpf: cpf,
    motivo: 'DEMISSAO',
    data_exclusao: '2025-07-01',
  });

  const params = {
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${__ENV.K6_TOKEN || 'token_homologacao'}`,
    },
  };

  const res = http.post(
    'https://api.sistema-saude.com/api/v1/beneficiarios/exclusao',
    payload,
    params
  );

  check(res, {
    'status 200': (r) => r.status === 200,
    'tempo < 3s':  (r) => r.timings.duration < 3000,
  });

  sleep(1);
}