/* eslint-disable prefer-const */
import { Router, Request, Response, NextFunction } from 'express';
import chakl from 'chalk';

export let ServerResponse = {
  success: async function (
    req: Request,
    res: Response,
    message: string,
    status?: number
  ) {
    let statusCode = status || 200;
    let statusMessage = message || '';

    res.status(statusCode).send({
      error: false,
      status: statusCode,
      body: statusMessage
    });
  },

  error: async function (
    req: Request,
    res: Response,
    message: any,
    status?: any
  ) {
    console.warn('Message--->', message, 'status--->', status);
    let statusCode = status || 500;
    let statusMessage = message || 'Internal server error';

    res.status(statusCode).send({
      error: true,
      status: statusCode,
      body: statusMessage
    });
  },
  throwError: async function(
    err: any,
    req: Request,
    res: Response,
    next?: NextFunction | any
  ) {
    console.log('error Heere---!', err);
  const message = err.msg || 'Error interno';
  const status = err.statusCode || 500;
  console.log('STATUS CONSOLE--->', status);
  await ServerResponse.error(req, res, message, status); 
  }
};

export let ConsoleResponse = {
  error: function (message: any, procedence: string) {
    console.warn(
      `${chakl.red(
        `[Handle Fatal Error >>> (${procedence})] \n`
      )} ${chakl.magentaBright(`====> ${message}`)}`
    );
  },
  success: function (procedence: string, message: string) {
    console.warn(
      `${chakl.green(
        `[Success Response xddd >>> (${procedence})]  \n`
      )}${chakl.greenBright(`====> ${JSON.stringify(message)}`)}`
    );
  }
};
