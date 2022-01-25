/* eslint-disable prefer-const */
import { nanoid } from 'nanoid';
import bcrypt from 'bcryptjs';
import * as auth from '../../../authorizations/index';
import chalk from 'chalk';
import controllerAuth from './index';
import controllerUser from '../users/index'
import { config } from '../../../configurations';
export default function (injectedStore: any) {
  let store = injectedStore;

  if (!store) {
    store = require('../../../store/store');
  }
  let table2 = 'authentications';
  let procedence = '[CONTROLLER AUTH]';

  const insert = (email: string, password: string, type?: any) => {
    console.log('this is the email auth--->', email);
    return new Promise(async (resolve, reject) => {
      const data: any = await (await store.query(
        table2,
        { email: email },
        new Array(type)
      ))[0]
      console.log('this is the data auth-->', data)
      if (!data) {
        reject({
          msg: 'correo no valido o usuario inexistente',
          statusCode: 400
        });
        return false;
      }
      const areEqual = await bcrypt.compare(password, data.encrypted_password);
      console.log('ARE EQUAL?--->', areEqual);
      if (areEqual == true) {
        const thistoken = await auth.sign(data);
        const dataAuth = await controllerAuth.update({
          token: thistoken,
          id: data.id
        });

        const {
          id,
          encrypted_password,
          created_at,
          updated_at,
          user_id,
          email,
          _id,
          ...newObject
        } = config.usingDb.mongoDB ? dataAuth._doc : dataAuth;
        const getUser: any = await controllerUser.get({filter:{id: user_id}})
      //console.log('this is the getUser--->', getUser)
       // const typeUpdate = 'user_update'
        //const userUpdated: any = await controllerUser.update({datas: Object.assign(getUser, {count_login: +getUser?.count_login + 1}), id: user_id, type: typeUpdate })
        //console.log('this is the userUpdated-->', userUpdated)
        resolve(Object.assign({ id: user_id, email: getUser.email, full_name:getUser.full_name }, newObject));
      } else {
        return  reject({ msg: 'Invalid Password login', statusCode: 400 });
      }
    });
  };

  //user auth
  const upsert = async (respon: any, data: any, type: string) => {
    console.log('DATAS UPSERT ---->', data);
    let authData: any = '';

    if ((type = 'users')) {
      authData = {
        data: {
          user_id: respon.id,
          encrypted_password: data.encrypted_password,
          email: data.email
        },
        type: 'insert_auth_users'
      };
    }

    console.log(
      `${procedence} ====> upsertAuth authData body -> ${chalk.blueBright(
        data
      )}`
    );
    return store.upsert(table2, authData);
  };

  const update = async (data: any) => {
    console.log('DATAS UPDATE ---->', data);
    let authData: any = '';
    authData = {
      data: {
        id: data.id,
        token: data.token ? data.token : '',
        encrypted_password: data.password ? data.password : '',
        email: data.email ? data.email : ''
      },
      type: 'update_auth_users'
    };

    console.log(
      `${procedence} ====> upsertAuth authData body -> ${chalk.blueBright(
        data
      )}`
    );
    return store.upsert(table2, authData);
  };

  const removeToken = async (req: any) => {
    const dataUser: any = await auth.decodeHeader(req);
    console.log('DATAS REMOVE TOKEN ---->', dataUser);
    let authData: any = '';
    authData = {
      data: {
        id: dataUser.id,
        token: ''
      },
      type: 'logout_auth_users'
    };
    console.log(
      `${procedence} ====> upsertAuth authData body -> ${chalk.blueBright(
        authData
      )}`
    );
    const updateToken = await store.upsert(table2, authData);
    const {
      id,
      _id,
      user_id,
      encrypted_password,
      email,
      created_at,
      updated_at,
      ...newobject
    } = config.usingDb.mongoDB ? updateToken._doc : updateToken;
    console.log('this is the newObject Logout--->', newobject);
    return newobject;
  };

  return {
    insert,
    upsert,
    update,
    remove: removeToken
  };
}
