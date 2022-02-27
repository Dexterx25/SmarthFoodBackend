"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
/* eslint-disable prefer-const */
const express_1 = __importDefault(require("express"));
const body_parser_1 = __importDefault(require("body-parser"));
const cors_1 = __importDefault(require("cors"));
const errors_1 = __importDefault(require("../utils/responses/errors"));
let { config } = require('../configurations/index');
const chalk_1 = __importDefault(require("chalk"));
//Swagger --->
//const SwaggerUI = require('swagger-ui-express');
//const SwaggerJsDoc = require('swagger-jsdoc');
//const swaggerDoc = require('../../src/swagger.json');
//import swaggerDoc from '../../src/swagger.json';
//import SwaggerUI from 'swagger-ui-express';
//import SwaggerJsDoc from 'swagger-jsdoc';
const app = (0, express_1.default)();
const path_1 = __importDefault(require("path"));
require('dotenv').config({ path: path_1.default.resolve(__dirname, '../../.env') });
app.use(body_parser_1.default.json());
app.use((0, cors_1.default)());
app.use(body_parser_1.default.urlencoded({ extended: false }));
//meddlewares-->
const network_1 = __importDefault(require("./components/users/network"));
const network_2 = __importDefault(require("./components/admin/network"));
const network_3 = __importDefault(require("./components/auth/network"));
const network_4 = __importDefault(require("./components/foods/network"));
const network_5 = __importDefault(require("./components/polls/network"));
const network_6 = __importDefault(require("./components/foods_market/network"));
const network_7 = __importDefault(require("./components/family_members/network"));
const network_8 = __importDefault(require("./components/family_members/network"));
const network_9 = __importDefault(require("./components/markets/network"));
const network_10 = __importDefault(require("./components/food_component/network"));
//app.use('/api-doc', SwaggerUI.serve, SwaggerUI.setup(swaggerDoc));
app.use('/users', network_1.default);
app.use('/foods', network_4.default);
app.use('/admins', network_2.default);
app.use('/authorization', network_3.default);
app.use('/polls', network_5.default);
app.use('/foods_to_markets', network_6.default);
app.use('/members', network_7.default);
app.use('/foods_market_foods_component', network_8.default);
app.use('/markets', network_9.default);
app.use('/food-component', network_10.default);
app.use(errors_1.default);
app.listen(config.api.port, () => {
    // eslint-disable-next-line prettier/prettier
    console.log(chalk_1.default.blue.underline.bgWhite(`Api Runing into ${config.api.host}:${config.api.port}`));
});
//# sourceMappingURL=index.js.map