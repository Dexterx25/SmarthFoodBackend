import bcrypt from 'bcryptjs';
import controllerAuth from '../auth/index';
import {
  midlleHandleError,
  Validator
} from '../../../utils/actions/personas/index';

import * as auth from '../../../authorizations/index';
import { familyMember, FamilyMembersModel } from './model';
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
  const table = 'family_members';

  async function insert({ datas, type }: any) {
    return new Promise(async (resolve, reject) => {
      const data = new FamilyMembersModel(datas);
      try {
        if(data.list.length){
              data.list.filter(async(i) =>{
                
                const dataRespon:any = await store.upsert(table, { data:i, type });
                if(dataRespon.length){
                  resolve(dataRespon)
                }
              })  
        }
      } catch (e) {
        await midlleHandleError(e, table, datas, resolve, reject);
      }
    });
  }

  async function insertList({ datas, type, token }: any) {
    return new Promise(async (resolve, reject) => {
      const {id}:any = await auth.decodeHeader({token})
      const data = new FamilyMembersModel(datas);
      try {
        if(data.list.length){
          const query = {token}
          const family_members: any = await list(query)

       const res =  data.list.filter(async(item) =>{  
           if(family_members.findIndex((i: any) => i == Object.assign(item, {user_id:id})) !== -1){
              if(item.parent !== 'ME'){
                const dataRes = await store.upsert(table, { data:Object.assign(item, {user_id: id}), type })
                return dataRes
              }
           } else{
            if(item.parent !== 'ME'){
              const dataRes = await store.upsert(table, { data:item, type })
              return dataRes
            } 
           }       
          
       }) 
          console.log('this is the RESSSS-->', res);
           resolve(res)
        }
      } catch (e) {
        await midlleHandleError(e, table, datas, resolve, reject);
      }
    });
  }

  async function list(query?: any) {
    return new Promise(async (resolve, reject) => {
      const {token} = query
      const {id}:any = await auth.decodeHeader({token})
      console.log('LIST CONTROLLERMember', id);
      try {
        let members = await cache.list(table);
        if (!members) {
          if(query){
            console.log('vamos SI HAY QUERY_-->', query)
            members = await store.query(table, {user_id: id}, new Array());
          }else{
            members = await store.list(table);
          }

          !members && reject({ msg: 'No hay miembros' });
          cache.upsert(members, table, '1');
        } else {
          console.log('datos traidos de la cache ddddd');
        }
        resolve(members);
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
        const theData = { type: 'get_family_member', querys: filter };
        let food: FamilyMembersModel = await cache.get(filter.id, table);
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
      const data = Object.assign(new FamilyMembersModel(datas), { id });

      try {
        const dataRespon: FamilyMembersModel = await store.upsert(table, { data, type });
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
    patch, 
    insertList
  };
}
