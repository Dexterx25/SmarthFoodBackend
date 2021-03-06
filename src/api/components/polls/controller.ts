import bcrypt from 'bcryptjs';
import controllerAuth from '../auth/index';
import {
  midlleHandleError,
  Validator
} from '../../../utils/actions/personas/index';

import * as auth from '../../../authorizations/index';
import {PollModel} from './model';
import errors from '../../../utils/responses/errors';
export default function (injectedStore: any, injectedCache: any) {
  let cache = injectedCache;
  let store = injectedStore;

  if (!store) {
    store = require('../../../store/dummy');
  }
  if (!cache) {
    cache = require('../../../store/dummy');
  }
  const table = 'polls';
  
  async function insert({ datas, type, token }: any) {
    return new Promise(async (resolve, reject) => {
    const decodedToken:any = await auth.decodeHeader({token})
    console.log('this is the decodedToken---->', decodedToken)
      // const responValidator = await Validator(datas);
      // if (responValidator) {
      //   reject({ msg: responValidator });
      //   return false;
      // }
      datas.user_id = decodedToken.id
      console.log('this is the data to pollModel-->', datas)
      const data = new PollModel(datas);
      try {
        const registerRespon: any = await store.upsert(table, { data, type });
        console.log('RES create Poll---', registerRespon);
        resolve( registerRespon );
      } catch (e) {
        await midlleHandleError(e, table, datas, resolve, reject);
      }
    });
  }


  async function list() {
    return new Promise(async (resolve, reject) => {
      console.log('LIST CONTROLLER');
      try {
        let foods = await cache.list(table);
        if (!foods) {
          foods = await store.list(table);
          !foods && reject({ msg: 'No hay platos de comida' });
          cache.upsert(foods, table);
        } else {
          console.log('datos traidos de la cache');
        }
        resolve(foods);
      } catch (error) {
        reject(error);
        return false;
      }
    });
  }

  async function get(data: any) {
    return new Promise(async (resolve, reject) => {
      try {
        const { filter, token} = data;
        const {id}:any = await auth.decodeHeader({token})
        const theData = { type: 'getPoll', querys: Object.assign(filter, {user_id:id}) };
        let food: PollModel = await cache.get(filter.id, table);
        if (!food) {
          console.log('no estaba en cachee, buscando en db');
          food = await store.get(theData, table);
        }
        await cache.upsert(food, table);
        resolve(food);
      } catch (error) {
        console.log('this error--->', error);
        return reject({ msg: 'maybe the food dont exist or is not active' });
      }
    });
  }

  async function update({ datas, id, type }: any) {
    return new Promise(async (resolve, reject) => {
      const responValidator = await Validator(datas);
      if (responValidator) {
        reject({ msg: responValidator });
        return false;
      }
      const data = Object.assign(new PollModel(datas), { id });

      try {
        const dataRespon: PollModel = await store.upsert(table, { data, type });
        console.log('this is the dataRespon--->', dataRespon);
        resolve(dataRespon);
      } catch (error) {
        midlleHandleError(error, table, data, resolve, reject);
      }
    });
  }

  async function remove({ id, type }: any) {
    return new Promise(async (resolve, reject) => {
      try {
        const dataRespon = await store.remove(table, { id, type });
        resolve(dataRespon);
      } catch (error) {
        midlleHandleError(error, table, { data: id }, resolve, reject);
      }
    });
  }

  async function patch({ id, type }: any) {
    return new Promise(async (resolve, reject) => {
      try {
        const data = { id, active: true };
        const dataRespon = await store.patch(table, { data, type });
        resolve(dataRespon);
      } catch (error) {
        midlleHandleError(error, table, { data: id }, resolve, reject);
      }
    });
  }

  return {
    insert,
    list,
    get,
    update,
    remove,
    patch
  };
}
