"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getCuriousFact = void 0;
/* eslint-disable prefer-const */
const cross_fetch_1 = __importDefault(require("cross-fetch"));
let apiBase = 'https://catfact.ninja/fact';
const getCuriousFact = () => __awaiter(void 0, void 0, void 0, function* () {
    return new Promise((resolve, reject) => __awaiter(void 0, void 0, void 0, function* () {
        try {
            const res = yield (0, cross_fetch_1.default)(apiBase);
            const RandonCuriousFact = yield res.json();
            console.log('this is the catFact fetch--->', RandonCuriousFact);
            resolve(RandonCuriousFact);
        }
        catch (error) {
            console.log('error trying to fetch corius fact!', error);
            reject({ msg: error, statusCode: 400 });
        }
    }));
});
exports.getCuriousFact = getCuriousFact;
//# sourceMappingURL=catfact.js.map