const { response } = require('express');
var express = require('express');
const session = require('express-session');
var router = express.Router();
const loginHelper = require('../sett/loginhelp')

/* GET users listing. */
router.get('/', function(req, res, next) {
  let user = req.session.user;
  if(req.session.loggedIn){
    if(user.dep == 'ambulance'){
      res.redirect('/ambulance/')
    }
    if(user.dep == 'cops'){
      res.redirect('/cops/')
    }
    if(user.dep == 'electrical'){
      res.redirect('/electrical/')
    }
    if(user.dep == 'fire'){
      res.redirect('/fire/')
    }
  }else{
    res.render('login/index', { title: 'Agent Login', for:"agent" });
  }
});
router.post('/', function(req, res, next) {
  loginHelper.agentLogin(req.body).then((resp)=>{
    if(resp.status == 'login'){
      req.session.loggedIn=true
      req.session.user=resp
      if(resp.dep == 'ambulance'){
        res.redirect('/ambulance/')
      }
      if(resp.dep == 'cops'){
        res.redirect('/cops/')
      }
      if(resp.dep == 'electrical'){
        res.redirect('/electrical/')
      }
      if(resp.dep == 'fire'){
        res.redirect('/fire/')
      }
    }
    if(resp.status == 'errpass'){
      res.write(
        '<script>window.alert("Password incorrect");window.location="/login/";</script>'
      );
    }
    if(resp.status == 'nouser'){
      res.write(
        '<script>window.alert("Email not found");window.location="/login/";</script>'
      );
    }

  })
});
router.get('/logout',(req,res)=>{
  if(req.session.loggedIn){
    res.header('Cache-Control', 'no-cache, private, no-store, must-revalidate, max-stale=0, post-check=0, pre-check=0');
    req.session.loggedIn=false;
    req.session.destroy();
    res.redirect('/login')
  }
})


router.get('/adlogout',(req,res)=>{
  if(req.session.loggedIn){
    res.header('Cache-Control', 'no-cache, private, no-store, must-revalidate, max-stale=0, post-check=0, pre-check=0');
    req.session.loggedIn=false;
    req.session.destroy();
    res.redirect('/admin')
  }
})

module.exports = router;
