var express = require('express');
var app = new express();
var router = express.Router();
var querystring = require('querystring');

const UserDao = require('../dao/callStackDao');
const userDao = new UserDao();

var callChainId = 1;

/* GET users listing. */
// next是一个中间件请求
router.get('/', async function(req, res, next) {

    // ES6新语法：await和promise
    let result = await userDao.queryAll();
    res.send(result);

});

router.post('/', async function(req, res, next) {
    userDao.truncate(req, res, next);

    var post = req.body;
    console.log(post);

    for (var key in post) {
        if (key == "callStack[]") {
            callStack = post[key];
        }
    }

    var stacks = new Array();
    for (var item in callStack) {
        var callChain = splitCallChain(callStack[item]);
        var addSqlParams = [(callChainId++).toString(), callChain[0], callChain[1], callChain[2]];

        stacks.push(addSqlParams);
    }

    let result = await userDao.insert(stacks);
    console.log(result);
});

function splitCallChain(callChain) {
    var array = new Array(3);
    var len = callChain.length;
    var servicePos = callChain.indexOf('service');
    var serviceTypePos = callChain.indexOf('serviceType');

    // TODO: 解析字符串，存在一些hard code。
    var chain = callChain.substr(13, servicePos-15);
    var service = callChain.substr(servicePos+10, serviceTypePos-servicePos-12);
    var serviceType = callChain.substr(serviceTypePos+14, len-serviceTypePos-15);

    array[0] = chain;
    array[1] = service;
    array[2] = serviceType;

    return array;
}

module.exports = router;