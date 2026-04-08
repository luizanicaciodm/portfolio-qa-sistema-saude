// Script de Performance — k6
// Cenário: até 1000 exclusões simultâneas de beneficiários
// Portfólio QA — Luiza Nicácio

import http from 'k6/http';
import { check, sleep } from 'k6';

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

export default function () {
  const payload = JSON.stringify({
    cpf: '123.456.789-09',
    motivo: 'DEMISSAO',
    data_exclusao: '2025-07-01',
  });

  const params = {
    headers: { 'Content-Type': 'application/json' },
  };

  const res = http.post(
    'https://api.sistema-saude.com/v1/beneficiarios/exclusao',
    payload,
    params
  );

  check(res, {
    'status 200': (r) => r.status === 200,
    'tempo < 3s':  (r) => r.timings.duration < 3000,
  });

  sleep(1);
}