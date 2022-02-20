import redis from 'redis';
import { config } from '../configurations/index';
import chalk from 'chalk';
const client: any = redis.createClient({
  host: config.redis.host,
  port: config.redis.port,
  auth_pass: process.env.REDIS_SRV_PASS,
});

// eslint-disable-next-line prettier/prettier
client.on('ready', (_: any) => console.log(chalk.blue.underline.bgWhite('Redis service is ready!')));

function list(table: string) {
  return new Promise((resolve, reject) => {
    client.get(table, (err: any, data: any) => {
      if (err) return reject(err);

      let res = data || null;
      if (data) {
        console.log('dataaaaaa cache list-->', data);
        res = JSON.parse(data);
      }
      resolve(res);
    });
  });
}

function get(id?: any, table?: string) {
  console.log('entra get Redis');
  return list(table + '_' + id);
}

async function upsert(data: any, table: string, timeout?: string) {
  let key = table;
  if (data && data.id) {
    key = key + '_' + data.id;
  }
  console.log('dataaaaaa cache upsert-->', data);
  const theTime = timeout ? timeout : 10
  client.setex(key, theTime, JSON.stringify(data));
  return true;
}

export { list, get, upsert };
