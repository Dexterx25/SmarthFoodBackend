import bcrypt from 'bcryptjs';
import controllerAuth from '../auth/index';
import {
  midlleHandleError,
  Validator
} from '../../../utils/actions/personas/index';

import * as auth from '../../../authorizations/index';
import {Markets} from './model';
import errors from '../../../utils/responses/errors';
import controllerMember from '../family_members/index'
import controllerPoll from '../polls/index';
import dayjs from 'dayjs';
export default function (injectedStore: any, injectedCache: any) {
  let cache = injectedCache;
  let store = injectedStore;

  if (!store) {
    store = require('../../../store/dummy');
  }
  if (!cache) {
    cache = require('../../../store/dummy');
  }
  const table = 'foods_market';
  
  async function insert({ datas, type, token }: any) {
    return new Promise(async (resolve, reject) => {
      const {id, gender_id, date_birtday}: any = await auth.decodeHeader({token});

      if (!datas.foodsListId.length) {
        reject({ msg: 'Es necesario suministrar la lista de recetas para crear mercado' });
        return false;
      }
      if(!datas.days_market){
        reject({ msg: 'Es necesario suministrar los dias de este merkado' });
        return false;
      }
     
      // const my_first_poll:any = await controllerPoll.get({filter, token})
      // console.log('this is my first_polllll-->', my_first_poll)
      // console.log('this is the DataFoodsIdList', datas.foodsListId)
      // console.log('THIS IS THE family-Member--->', family_members)
      // let listFamily_member_id = []
      //     listFamily_member_id = family_members.reduce((acc:any, item:any) =>{
      //     if(item.id){
      //       acc.push({
      //         family_member_id:item.id
      //       })
      //     }
      //     return acc
      //    },[])

      // let data = {}
      //      datas.listFamily_member_id = listFamily_member_id
      //      datas.user_id = id
      //      datas.foodsListId = datas.foodsListId.reduce((acc:any, item:any) =>{
      //       if(item.id){
      //         acc.push({
      //           food_id:item.id,
      //           date:item.date
      //         })
      //       }
      //       return acc
      //      }, []) 
      //      datas.days_market = my_first_poll.times_recurral_market == 'Mensual' ? '30' : my_first_poll.times_recurral_market == 'Quincenal' ? '15'  : my_first_poll.times_recurral_market == 'Semanal' ? '7' : ''
      //      datas.date_init = datas.foodsListId.sort((a:any, b:any) => +new Date(a.date) - +new Date(b.date))
      //      // my_first_poll.find((e:any) => e.type_id == '1').times_recurral_market
      //      console.log('this is the dataList-->', datas)
          
      //      data = new Markets(datas);
      //      console.log('AQUIII-->',datas.date_init[datas.date_init.length - 1])
      try {
        const filter:any = {type_id: '1'};
        const query = {token}
        const family_members: any = await controllerMember.list(query)
        console.log('data FamilyMembers-->', family_members);
      //   const dataMembersAgruped = datas.listFamily_member_id.reduce((acc:any, item:any) =>{
      //       if(item){
      //           acc.push({
      //             user_id:datas.user_id,
      //             family_member_id: item.family_member_id,
      //             times_recurral_market:datas.days_market, 
      //             date_init:dayjs(datas.date_init[0].date).format('YYYY-MM-DD hh:mm'),
      //             date_finish:dayjs(datas.date_init[datas.date_init.length - 1].date).format('YYYY-MM-DD hh:mm')
      //           })
      //       }
      //     return acc
      //   },[])
      //   console.log('dateFiish--->', dataMembersAgruped)
      //  let registerRespon:any[] = []
      //   for (let i = 0; i < datas.foodsListId.length; i++) {
      //     const {food_id} = datas.foodsListId[i]
      //       for (let k = 0; k < dataMembersAgruped.length; k++) {
      //       const dataMembersPrevAgruped = dataMembersAgruped[k]
      //       const dataToSave = {
      //         ...dataMembersPrevAgruped,
      //         food_id
      //       }
      //       console.log('this is the DATATOSAVE-->', dataToSave)
      //         const respo = await store.upsert(table, { data:dataToSave, type }); 
      //         registerRespon = [...registerRespon, respo]
      //       }
      //   }
      
      //   console.log('RES create Foood---', registerRespon);
        resolve(family_members );
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
          cache.upsert(foods, table, '0');
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
        const { filter } = data;
        const theData = { type: 'getFood', querys: filter };
        let food: Markets = await cache.get(filter.id, table);
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
      const data = Object.assign(new Markets(datas), { id });

      try {
        const dataRespon: Markets = await store.upsert(table, { data, type });
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
