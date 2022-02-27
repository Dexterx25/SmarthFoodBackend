import bcrypt from 'bcryptjs';
import controllerAuth from '../auth/index';
import {
  midlleHandleError,
  Validator
} from '../../../utils/actions/personas/index';

import * as auth from '../../../authorizations/index';
import {FoodModel} from './model';
import errors from '../../../utils/responses/errors';
import { CateoryFoodEnum } from './model';
export default function (injectedStore: any, injectedCache: any) {
  let cache = injectedCache;
  let store = injectedStore;

  if (!store) {
    store = require('../../../store/dummy');
  }
  if (!cache) {
    cache = require('../../../store/dummy');
  }
  const table = 'foods';
  
  async function insert({ datas, type }: any) {
    return new Promise(async (resolve, reject) => {
      const responValidator = await Validator(datas);
      if (responValidator) {
        reject({ msg: responValidator });
        return false;
      }
      const data = new FoodModel(datas);
      try {
        const registerRespon: any = await store.upsert(table, { data, type });
        console.log('RES create Foood---', registerRespon);
        resolve( registerRespon );
      } catch (e) {
        await midlleHandleError(e, table, datas, resolve, reject);
      }
    });
  }


  async function list(query?: string) {
    return new Promise(async (resolve, reject) => {
      console.log('LIST CONTROLLER');
      try {
        let foods = await cache.list(table);
        if (!foods) {
          if(query?.length){
            const categoration = query == 'dinner' ? CateoryFoodEnum[query] : query == 'lunch' ? CateoryFoodEnum[query] : query == 'breakfast' && CateoryFoodEnum[query] 
            foods = await store.query(table, {category_id: categoration}, new Array('category_foods'));
          }else{
            foods = await store.list(table);
          }

          !foods && reject({ msg: 'No hay platos de comida' });
          cache.upsert(foods, table, '1');
        } else {
          console.log('datos traidos de la cache ddddd');
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
        const { filter } = data;
        const theData = { type: 'getFood', querys: filter };
        let food: FoodModel = await cache.get(filter.id, table);
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
 
  async function update({ datas, file, token, id, type }: any) {
    return new Promise(async (resolve, reject) => {
    //  const responValidator = await Validator(datas);
    //  if (responValidator) {
    //    reject({ msg: responValidator });
    //    return false;
    //  }
       const decoded = await auth.decodeHeader({token})
       let avatarPath = ''
       if(file){
         console.log('PASOOOOOOOO')
         avatarPath = `http://backend.smarthfood.fourin.co/app/photos/` + file.filename 
      }
      datas.picture = avatarPath
      console.log('la imagen-->', avatarPath)
      const data = Object.assign(new FoodModel(datas), { id });

      try {
        console.log('data----------->', data)
        const dataRespon: FoodModel = await store.upsert(table, { data, type });
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
