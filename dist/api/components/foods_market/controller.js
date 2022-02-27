"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __rest = (this && this.__rest) || function (s, e) {
    var t = {};
    for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p) && e.indexOf(p) < 0)
        t[p] = s[p];
    if (s != null && typeof Object.getOwnPropertySymbols === "function")
        for (var i = 0, p = Object.getOwnPropertySymbols(s); i < p.length; i++) {
            if (e.indexOf(p[i]) < 0 && Object.prototype.propertyIsEnumerable.call(s, p[i]))
                t[p[i]] = s[p[i]];
        }
    return t;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const index_1 = require("../../../utils/actions/personas/index");
const auth = __importStar(require("../../../authorizations/index"));
const model_1 = require("./model");
const index_2 = __importDefault(require("../family_members/index"));
const index_3 = __importDefault(require("../polls/index"));
const dayjs_1 = __importDefault(require("dayjs"));
function default_1(injectedStore, injectedCache) {
    let cache = injectedCache;
    let store = injectedStore;
    if (!store) {
        store = require('../../../store/dummy');
    }
    if (!cache) {
        cache = require('../../../store/dummy');
    }
    const table = 'foods_market';
    function insert({ datas, type, token }) {
        return __awaiter(this, void 0, void 0, function* () {
            return new Promise((resolve, reject) => __awaiter(this, void 0, void 0, function* () {
                const { id, gender_id, date_birtday } = yield auth.decodeHeader({ token });
                if (!datas.foodsListId.length) {
                    reject({ msg: 'Es necesario suministrar la lista de recetas para crear mercado' });
                    return false;
                }
                if (!datas.days_market) {
                    reject({ msg: 'Es necesario suministrar los dias de este merkado' });
                    return false;
                }
                try {
                    let listFamily_member_id = [];
                    const filter = { type_id: '1' };
                    const query = { token };
                    const my_first_poll = yield index_3.default.get({ filter, token });
                    const family_members = yield index_2.default.list(query);
                    listFamily_member_id = family_members.reduce((acc, item) => {
                        if (item.id) {
                            acc.push({
                                family_member_id: item.id,
                                date_birtday: item.date_birtday,
                                gender: item.gender_id == '1' ? 'Male' : item.gender_id == '2' ? 'Female' : null,
                                gender_id: item.gender_id
                            });
                        }
                        return acc;
                    }, []);
                    datas.listFamily_member_id = listFamily_member_id;
                    let data = {};
                    datas.user_id = id;
                    datas.foodsListId = datas.foodsListId.reduce((acc, item) => {
                        if (item.id) {
                            acc.push({
                                food_id: item.id,
                                category_name: item.category_name,
                                components: item.components,
                                date: item.date
                            });
                        }
                        return acc;
                    }, []);
                    datas.days_market = my_first_poll.times_recurral_market == 'Mensual' ? '30' : my_first_poll.times_recurral_market == 'Quincenal' ? '15' : my_first_poll.times_recurral_market == 'Semanal' ? '7' : '';
                    datas.date_init = datas.foodsListId.sort((a, b) => +new Date(a.date) - +new Date(b.date));
                    // console.log('this is the dataList-->', datas)
                    data = new model_1.Markets(datas);
                    //  console.log('AQUIII-->',datas.date_init[datas.date_init.length - 1])
                    //   console.log('data FamilyMembers-->', family_members);
                    const dataMembersAgruped = datas.listFamily_member_id.reduce((acc, item) => {
                        if (item) {
                            acc.push({
                                user_id: datas.user_id,
                                family_member_id: item.family_member_id,
                                date_birtday: item.date_birtday,
                                gender: item.gender,
                                gender_id: item.gender_id,
                                times_recurral_market: datas.days_market,
                                date_init: (0, dayjs_1.default)(datas.date_init[0].date).format('YYYY-MM-DD hh:mm'),
                                date_finish: (0, dayjs_1.default)(datas.date_init[datas.date_init.length - 1].date).format('YYYY-MM-DD hh:mm')
                            });
                        }
                        return acc;
                    }, []);
                    // console.log('dateFiish--->', dataMembersAgruped)
                    let registerRespon = [];
                    let dataToCreateComponentFoods = [];
                    for (let i = 0; i < datas.foodsListId.length; i++) {
                        const { food_id, category_name, components } = datas.foodsListId[i];
                        for (let k = 0; k < dataMembersAgruped.length; k++) {
                            const dataMembersPrevAgruped = dataMembersAgruped[k];
                            const { gender, date_birtday, gender_id, date_finish, times_recurral_market, date_init } = dataMembersPrevAgruped, rest = __rest(dataMembersPrevAgruped, ["gender", "date_birtday", "gender_id", "date_finish", "times_recurral_market", "date_init"]);
                            const dataToSave = Object.assign(Object.assign({}, rest), { food_id });
                            //    console.log('this is the DATATOSAVE-->', dataToSave)
                            const respo = yield store.upsert(table, { data: dataToSave, type });
                            registerRespon = [...registerRespon, respo];
                            dataToCreateComponentFoods = [...dataToCreateComponentFoods, Object.assign(respo, {
                                    category_name,
                                    components,
                                    gender,
                                    date_birtday,
                                    gender_id,
                                    date_init: (0, dayjs_1.default)(datas.date_init[0].date).format('YYYY-MM-DD'),
                                    date_finish: (0, dayjs_1.default)(datas.date_init[datas.date_init.length - 1].date).format('YYYY-MM-DD'),
                                    times_recurral_market
                                })];
                        }
                    }
                    const itemTOCreateMarket = {
                        times_recurral_market: datas.days_market,
                        date_init: (0, dayjs_1.default)(datas.date_init[0].date).format('YYYY-MM-DD hh:mm'),
                        date_finish: (0, dayjs_1.default)(datas.date_init[datas.date_init.length - 1].date).format('YYYY-MM-DD hh:mm'),
                        user_id: datas.user_id
                    };
                    const MarketCreated = yield store.upsert('markets', { data: itemTOCreateMarket, type: 'markets_register' });
                    const dataBeForeAssingFoodComponent = dataToCreateComponentFoods;
                    const listFoodMarketComponent = yield store.query('food_component', '', new Array('category_foods', 'genders', 'age_ranges'));
                    let dataAgrupedToCreateAssign = [];
                    let dataAgrupedTuAssing = [];
                    for (let i = 0; i < dataBeForeAssingFoodComponent.length; i++) {
                        const item = dataBeForeAssingFoodComponent[i];
                        const posibleDataForComponentsToThisFood = yield listFoodMarketComponent.filter(k => JSON.parse(item.components).includes(k.skuu));
                        const posibleDataForComponentsToThisMemberGender = yield posibleDataForComponentsToThisFood.filter(y => y.gender_id == item.gender_id);
                        const today = (0, dayjs_1.default)(new Date()).format('YYYY-MM-DD');
                        const dateDifference = (0, dayjs_1.default)(today).diff((0, dayjs_1.default)(item.date_birtday).format('YYYY-MM-DD'), "years");
                        const posibleDataForComponentsToThisRagueAges = yield posibleDataForComponentsToThisMemberGender.filter(o => `${dateDifference}` >= o.range_init && `${dateDifference}` <= o.range_finish);
                        const posibleDataComponentsToTypeFoodTime = yield posibleDataForComponentsToThisRagueAges.filter(e => e.category_name == item.category_name);
                        const concatec = yield posibleDataComponentsToTypeFoodTime.reduce((acc, k) => {
                            acc.push(Object.assign(Object.assign({}, k), { food_market_id: item.id }));
                            return acc;
                        }, []);
                        dataAgrupedTuAssing = [...dataAgrupedTuAssing, ...concatec];
                    }
                    for (let i = 0; i < dataAgrupedTuAssing.length; i++) {
                        const item = dataAgrupedTuAssing[i];
                        dataAgrupedToCreateAssign.push({
                            user_id: id,
                            food_market_id: item.food_market_id,
                            food_component_id: item.id,
                            markets_id: MarketCreated.id
                        });
                    }
                    console.log('dataAgruped to asign component Food to FoodMarketId-->', dataAgrupedToCreateAssign);
                    yield dataAgrupedToCreateAssign.filter((item) => __awaiter(this, void 0, void 0, function* () {
                        yield store.upsert('foods_market_food_component', { data: item, type: 'foods_market_food_component_register' });
                    }));
                    /// create foods Component Asosation 
                    // reject()
                    //return false
                    resolve(registerRespon);
                }
                catch (e) {
                    yield (0, index_1.midlleHandleError)(e, table, datas, resolve, reject);
                }
            }));
        });
    }
    function list() {
        return __awaiter(this, void 0, void 0, function* () {
            return new Promise((resolve, reject) => __awaiter(this, void 0, void 0, function* () {
                console.log('LIST CONTROLLER');
                try {
                    let foods = yield cache.list(table);
                    if (!foods) {
                        foods = yield store.list(table);
                        !foods && reject({ msg: 'No hay platos de comida' });
                        cache.upsert(foods, table, '0');
                    }
                    else {
                        console.log('datos traidos de la cache');
                    }
                    resolve(foods);
                }
                catch (error) {
                    reject(error);
                    return false;
                }
            }));
        });
    }
    function get(data) {
        return __awaiter(this, void 0, void 0, function* () {
            return new Promise((resolve, reject) => __awaiter(this, void 0, void 0, function* () {
                try {
                    const { filter } = data;
                    const theData = { type: 'getFood', querys: filter };
                    let food = yield cache.get(filter.id, table);
                    if (!food) {
                        console.log('no estaba en cachee, buscando en db');
                        food = yield store.get(theData, table);
                    }
                    yield cache.upsert(food, table);
                    resolve(food);
                }
                catch (error) {
                    console.log('this error--->', error);
                    return reject({ msg: 'maybe the food dont exist or is not active' });
                }
            }));
        });
    }
    function update({ datas, id, type }) {
        return __awaiter(this, void 0, void 0, function* () {
            return new Promise((resolve, reject) => __awaiter(this, void 0, void 0, function* () {
                const responValidator = yield (0, index_1.Validator)(datas);
                if (responValidator) {
                    reject({ msg: responValidator });
                    return false;
                }
                const data = Object.assign(new model_1.Markets(datas), { id });
                try {
                    const dataRespon = yield store.upsert(table, { data, type });
                    console.log('this is the dataRespon--->', dataRespon);
                    resolve(dataRespon);
                }
                catch (error) {
                    (0, index_1.midlleHandleError)(error, table, data, resolve, reject);
                }
            }));
        });
    }
    function remove({ id, type }) {
        return __awaiter(this, void 0, void 0, function* () {
            return new Promise((resolve, reject) => __awaiter(this, void 0, void 0, function* () {
                try {
                    const dataRespon = yield store.remove(table, { id, type });
                    resolve(dataRespon);
                }
                catch (error) {
                    (0, index_1.midlleHandleError)(error, table, { data: id }, resolve, reject);
                }
            }));
        });
    }
    function patch({ id, type }) {
        return __awaiter(this, void 0, void 0, function* () {
            return new Promise((resolve, reject) => __awaiter(this, void 0, void 0, function* () {
                try {
                    const data = { id, active: true };
                    const dataRespon = yield store.patch(table, { data, type });
                    resolve(dataRespon);
                }
                catch (error) {
                    (0, index_1.midlleHandleError)(error, table, { data: id }, resolve, reject);
                }
            }));
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
exports.default = default_1;
//# sourceMappingURL=controller.js.map