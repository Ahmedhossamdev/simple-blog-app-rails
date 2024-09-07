import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 100,
  duration: '30s',
};

export default function () {
  const url = 'http://localhost:3000/articles';
  const payload = JSON.stringify({
    article: {
      title: `Test Article ${__VU} - ${__ITER}`,
      body: `This is a test article body created by VU ${__VU} on iteration ${__ITER}.`
    }
  });

  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };

  const response = http.post(url, payload, params);

  check(response, {
    'status is 200': (r) => r.status === 200,
  });

  sleep(1);
}
