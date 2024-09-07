require 'json'

k6_script = <<~JAVASCRIPT
import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  vus: 100,
  duration: '30s',
};

export default function () {
  http.get('http://localhost:3000/articles/1');
  sleep(1);
}
JAVASCRIPT

File.write('article_stress_test.js', k6_script)
puts "k6 test script generated: article_stress_test.js"
