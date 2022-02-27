/* eslint-disable no-var */
/* eslint-disable prefer-const */
export const insertTionDatas = (data: any, type: string) => {
  console.log('insertionDatas Model--->', data, type);
  let $data: any = {};
  for (var k in data) {
    if (data[k]) {
      $data[k] = data[k];
    }
  }
  let $keys;
  let $values;
  switch (type) {
    case 'email_register':
    case 'food_register':
    case 'facebook_register':
    case 'ios_register':
    case 'insert_auth_users':
    case 'poll_register':
    case 'family_member_register':
    case 'food_market_register':
    case 'foods_market_food_component_register':
    case 'markets_register':
    
      $keys = Object.keys($data).toString().replace('[', '').replace(']', '');
      $values = `${Object.values($data)
        .map((e) => `'${e}'`)
        .toString()}`;
      console.log('values intoActions-->', $values);
      return {
        keys: $keys,
        values: $values
      };
      break;

    default:
      break;
  }
};

export const queryDatas = (table: string, typequery: any, joins: any) => {
  console.log('queryAction!', table, typequery, joins);
  let query: any = Object.keys(typequery);
  let queryValues: any = Object.values(typequery);
  let theJoinQuery = '';
  let theQuery = '';
  let selected = ''
  switch (table) {
    case 'foods':
      if (joins) {
        theJoinQuery = `INNER JOIN ${joins[0]} ON ${table}.${query[0]} = ${joins[0]}.id`;
        selected = 'foods.id, foods.picture, foods.description, foods.name, category_foods.category_name, foods.components'
      }
      theQuery = `WHERE ${table}.${query[0]} = '${queryValues[0]}'`;
      console.log('datasFilterxd--->', theJoinQuery, 'query-->', theQuery);
      return {
        theJoinQuery,
        theQuery,
        selected
      };
    break;
    case 'authentications':
      if (joins) {
        theJoinQuery = `INNER JOIN ${joins[0]} ON ${table}.${query[0]} = ${joins[0]}.${query[0]}`;
      }
      theQuery = `WHERE ${table}.${query[0]} = '${queryValues[0]}'`;
      console.log('datasFilter--->', theJoinQuery, 'query-->', theQuery);
      return {
        theJoinQuery,
        theQuery
      };
      break;
      case 'family_members':
        console.log('consumimos mis miembros-->', query, queryValues)
        theQuery = `WHERE ${table}.${query[0]} = '${queryValues[0]}'`;
        return{
          theQuery
        }
      case 'food_component':
        console.log('entramos en foodComponent')
        
        if (joins) {
          theJoinQuery = `INNER JOIN category_foods ON category_foods.id = food_component.category_id INNER JOIN genders ON genders.id = food_component.gender_id INNER JOIN age_ranges ON age_ranges.id = food_component.age_ranges_id`;
          selected = 'food_component.id, food_component.image, food_component.description, food_component.skuu, genders.id as gender_id, age_ranges.range_init, age_ranges.range_finish, category_foods.category_name'
        }
       // theQuery = `WHERE ${table}.${query[0]} '${queryValues[0]}'`
        return {
          theJoinQuery,
          theQuery,
          selected
        };
  case 'foods_market_food_component':
    theQuery = `WHERE ${table}.${query[0]}`
  return {
    
  }
  case 'markets':
  //  console.log('THIS IS THE QUERY-->', query)
   // console.log('this is the queryVAlues-->', queryValues)
    if (joins) {
      theJoinQuery = `INNER JOIN foods_market_food_component ON foods_market_food_component.markets_id = markets.id  INNER JOIN  foods_market ON foods_market_food_component.food_market_id = foods_market.id INNER JOIN food_component ON foods_market_food_component.food_component_id = food_component.id INNER JOIN category_food_component ON category_food_component.id = food_component.category_food_component_id INNER JOIN category_foods ON category_foods.id = food_component.category_id INNER JOIN foods ON foods.id = foods_market.food_id`;
      selected = 'markets.id, markets.user_id, foods.name AS recipie_name, markets.date_init, markets.date_finish, markets.created_at, markets.updated_at, foods_market_food_component.id AS foods_market_food_component_id, food_component.id AS food_component_id, food_component.unit_measure_home, food_component.net_weight, food_component.gross_weight, food_component.name AS ingredient_name,  food_component.useful_weight, food_component.category_food_component_id, food_component.category_id, food_component.image'
    }else {
      selected = '*'
    }
    theQuery = `WHERE ${table}.${query[0]} = '${queryValues[0]}'`
    console.log('this i the query-->', theQuery)
    return {
      theJoinQuery,
      theQuery,
      selected
    };
    default:
      break;
  }
};
export const updateDatas = (data: any, type: string) => {
  console.log('Updata Mock', data, type);
  let $data: any = {};
  for (var k in data) {
    if (data[k]) {
      $data[k] = data[k];
    }
  }
  console.log('DATASSSS_-', $data);
  let keysAndValuesToUpdate: any[] = [];
  let conditions: any[] = [];
  switch (type) {
    case 'user_update':
    case 'update_user_forAdmin':
    case 'food_update':
      console.log('entró a update', data);
      for (let i = 0; i < Object.keys($data).length; i++) {
        const dataKeys: any = Object.keys($data)[i];
        const dataValues: any = Object.values($data)[i];
        keysAndValuesToUpdate.push(` ${dataKeys} = '${dataValues.toString()}'`);
      }
      console.log('Put OUT-->', keysAndValuesToUpdate, conditions);
      conditions.push(` WHERE id = '${data.id.toString()}'`);
      console.log('coditions', conditions);
      return {
        keysAndValuesToUpdate: keysAndValuesToUpdate
          .toString()
          .replace('[', '')
          .replace(']', ''),
        conditions: conditions.toString().replace('[', '').replace(']', '')
      };
      break;
    case 'update_auth_users':
      console.log('entró a update', data);
      for (let i = 0; i < Object.keys($data).length; i++) {
        const dataKeys: any = Object.keys($data)[i];
        const dataValues: any = Object.values($data)[i];
        keysAndValuesToUpdate.push(` ${dataKeys} = '${dataValues.toString()}'`);
      }
      console.log('Put OUT-->', keysAndValuesToUpdate, conditions);
      conditions.push(` WHERE user_id = '${data.id.toString()}'`);
      console.log('coditions', conditions);
      return {
        keysAndValuesToUpdate: keysAndValuesToUpdate
          .toString()
          .replace('[', '')
          .replace(']', ''),
        conditions: conditions.toString().replace('[', '').replace(']', '')
      };
      break;
    case 'logout_auth_users':
      console.log('entró a logout', data);
      for (let i = 0; i < Object.keys($data).length; i++) {
        const dataKeys: any = Object.keys($data)[i];
        const dataValues: any = Object.values($data)[i];
        keysAndValuesToUpdate.push(`token = ''`);
      }
      conditions.push(` WHERE user_id = '${data.id.toString()}'`);
      console.log('coditions', conditions);
      return {
        keysAndValuesToUpdate: keysAndValuesToUpdate
          .toString()
          .replace('[', '')
          .replace(']', ''),
        conditions: conditions.toString().replace('[', '').replace(']', '')
      };
    default:
      break;
  }
};

export const getData = (querys: any, type: string) => {
  let $data: any = {};
  for (var k in querys) {
    if (querys[k] != null) $data[k] = querys[k];
  }
  let theQuery: any[] = [];
  switch (type) {
    case 'getUser':
      for (let i = 0; i < Object.keys($data).length; i++) {
        if (Object.keys($data).length <= 1) {
          console.log('entra aqui-->');
          theQuery.push(
            `WHERE ${Object.keys($data)[i]} = '${
              Object.values($data)[i]
            }' and active = 'TRUE'`
          );
        }
      }
     return {
        theQuery: theQuery.toString().replace('[', '').replace(']', '')
      };
    case 'getPoll':
      console.log('getPoll SIIIII', querys);
          theQuery.push(
            `WHERE user_id = '${querys.user_id}' AND type_id = '${querys.type_id}'`
          );
      return {
        theQuery: theQuery.toString().replace('[', '').replace(']', '')
      };

    default:
      break;
  }
};

export const patchDatas = (data: any, type: string) => {
  console.log('Updata Mock', data, type);
  let $data: any = {};
  for (var k in data) {
    if (data[k]) {
      $data[k] = data[k];
    }
  }
  console.log('DATASSSS_-', $data);
  let keysAndValuesToUpdate: any[] = [];
  let conditions: any[] = [];
  switch (type) {
    case 'user_patch_active':
      for (let i = 0; i < Object.keys($data).length; i++) {
        const dataKeys: any = Object.keys($data)[i];
        const dataValues: any = Object.values($data)[i];
        keysAndValuesToUpdate.push(` ${dataKeys} = '${dataValues.toString()}'`);
      }
      console.log('patch OUT-->', keysAndValuesToUpdate, conditions);
      conditions.push(` WHERE id = '${data.id.toString()}'`);
      console.log('coditions patch', conditions);
      return {
        keysAndValuesToUpdate: keysAndValuesToUpdate
          .toString()
          .replace('[', '')
          .replace(']', ''),
        conditions: conditions.toString().replace('[', '').replace(']', '')
      };
      break;

    default:
      break;
  }
};
