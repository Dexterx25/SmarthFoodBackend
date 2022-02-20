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
import { foodsMarketFoodComponentDTO, foodsMarketsCreatedDTO, food_componentsInterface } from './interfaces';
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
     
      try {
        let listFamily_member_id = []
        const filter:any = {type_id: '1'};
        const query = {token}
        const my_first_poll:any = await controllerPoll.get({filter, token})
        const family_members: any = await controllerMember.list(query)
        listFamily_member_id = family_members.reduce((acc:any, item:any) =>{
          if(item.id){
            acc.push({
              family_member_id:item.id,
              date_birtday:item.date_birtday,
              gender:item.gender_id == '1' ? 'Male' : item.gender_id == '2' ? 'Female' : null, 
              gender_id:item.gender_id
            })
          }
          return acc
         },[])
         datas.listFamily_member_id = listFamily_member_id
         let data = {}
         datas.user_id = id
         datas.foodsListId = datas.foodsListId.reduce((acc:any, item:any) =>{
          if(item.id){
            acc.push({
              food_id:item.id,
              category_name:item.category_name,
              components:item.components,
              date:item.date
            })
          }
          return acc
         }, []) 
         datas.days_market = my_first_poll.times_recurral_market == 'Mensual' ? '30' : my_first_poll.times_recurral_market == 'Quincenal' ? '15'  : my_first_poll.times_recurral_market == 'Semanal' ? '7' : ''
         datas.date_init = datas.foodsListId.sort((a:any, b:any) => +new Date(a.date) - +new Date(b.date))
        // console.log('this is the dataList-->', datas)
       
         data = new Markets(datas);
       //  console.log('AQUIII-->',datas.date_init[datas.date_init.length - 1])
     //   console.log('data FamilyMembers-->', family_members);
        const dataMembersAgruped = datas.listFamily_member_id.reduce((acc:any, item:any) =>{
            if(item){
                acc.push({
                  user_id:datas.user_id,
                  family_member_id: item.family_member_id,
                  date_birtday:item.date_birtday,
                  gender:item.gender,
                  gender_id:item.gender_id,
                  times_recurral_market:datas.days_market, 
                  date_init:dayjs(datas.date_init[0].date).format('YYYY-MM-DD hh:mm'),
                  date_finish:dayjs(datas.date_init[datas.date_init.length - 1].date).format('YYYY-MM-DD hh:mm')
                })
            }
          return acc
        },[])
       // console.log('dateFiish--->', dataMembersAgruped)
       let registerRespon:any[] = []
       let dataToCreateComponentFoods: any[] = [];
        for (let i = 0; i < datas.foodsListId.length; i++) {
          const {food_id, category_name, components} = datas.foodsListId[i]
            for (let k = 0; k < dataMembersAgruped.length; k++) {
            const dataMembersPrevAgruped = dataMembersAgruped[k]
            const {gender, date_birtday, gender_id, ...rest} = dataMembersPrevAgruped
            const dataToSave = {
              ...rest,
              food_id,
            }
        //    console.log('this is the DATATOSAVE-->', dataToSave)
              const respo = await store.upsert(table, { data:dataToSave, type }); 
              registerRespon = [...registerRespon, respo]
              dataToCreateComponentFoods = [...dataToCreateComponentFoods, Object.assign(respo, {
                category_name,
                components,
                gender,
                date_birtday,
                gender_id
              })]
            }
        }
      
      //  console.log('RES create Foood---', registerRespon);
      //  console.log('RES foods To create componts foods', dataToCreateComponentFoods)
        //store.query(table, {user_id: id}, new Array());
        const dataBeForeAssingFoodComponent:foodsMarketsCreatedDTO[] = dataToCreateComponentFoods;
        const listFoodMarketComponent:food_componentsInterface[] =  await store.query('food_component', '', new Array('category_foods', 'genders', 'age_ranges'));
        // await store.list('food_component')
     ///   console.log('this is the listFoodMarketComponents--->', listFoodMarketComponent)
        const dataAgrupedToCreateAssign:foodsMarketFoodComponentDTO[] = dataBeForeAssingFoodComponent.reduce((acc:foodsMarketFoodComponentDTO[], item:foodsMarketsCreatedDTO)=> {

           if(item.id){
            const posibleDataForComponentsToThisFood = listFoodMarketComponent.filter(k => JSON.parse(item.components).includes(k.skuu));
            const posibleDataForComponentsToThisMemberGender =  posibleDataForComponentsToThisFood.filter(y => y.gender_id == item.gender_id)
            const today = dayjs(new Date()).format('YYYY-MM-DD')
            const dateDifference = dayjs(today).diff(dayjs(item.date_birtday).format('YYYY-MM-DD'), "years") 
            const posibleDataForComponentsToThisRagueAges = posibleDataForComponentsToThisMemberGender.filter(o => `${dateDifference}` >= o.range_init && `${dateDifference}` <= o.range_finish  )
            const posibleDataComponentsToTypeFoodTime = posibleDataForComponentsToThisRagueAges.find( e => e.category_name == item.category_name) 
            console.log('posible data--->', posibleDataForComponentsToThisFood.pop());
            console.log('posible Data this Ranges-->', posibleDataForComponentsToThisRagueAges)
            console.log('date_birtDay-->', item.date_birtday)
            console.log('DIFERENCIA-->', dateDifference)
            console.log('THE FIND-->', posibleDataComponentsToTypeFoodTime)

               acc.push({
                 user_id:id,
                 food_market_id:item.id, 
                 food_component_id:posibleDataComponentsToTypeFoodTime?.id!
               })
             }
          return acc
        },[])
        console.log('dataAgruped to asign component Food to FoodMarketId-->', dataAgrupedToCreateAssign);
      await  dataAgrupedToCreateAssign.filter(async(item) => {
          await store.upsert('foods_market_food_component', {data:item, type: 'foods_market_food_component_register'})          
        })
        /// create foods Component Asosation 
    
       resolve(registerRespon );
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
