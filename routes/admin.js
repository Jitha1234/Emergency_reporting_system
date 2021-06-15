const { response } = require('express');
var express = require('express');
var router = express.Router();
const adminfitch = require('../sett/adminfitch')

/* GET users listing. */
router.get('/', function(req, res, next) {
  let user = req.session.user ;
  if(req.session.loggedIn){
    if(user.dep === "admin"){
      res.redirect('/admin/home')
    }else{
      res.redirect('/login')
    }
  }else{
    res.render('login/index', { title: 'Admin Login', for:"admin" });
  }
});

router.post('/', function(req, res, next) {
  adminfitch.adminLogin(req.body).then((resp)=>{
    if(resp.status == 'login'){
      req.session.loggedIn=true
      req.session.user=resp
      res.redirect('/admin/home');
    }
    if(resp.status == 'errpass'){
      res.write(
        '<script>window.alert("Password incorrect");window.location="/admin/";</script>'
      );
    }
    if(resp.status == 'nouser'){
      res.write(
        '<script>window.alert("Email not found");window.location="/admin/";</script>'
      );
    }
  })
  
});
router.get('/home', function(req, res) {
  let user = req.session.user
  if(req.session.loggedIn){
    if(user.dep === 'admin'){
      res.render('admin/dindex', { title: 'Dashboard', post:'Sys Admin',user });
    }
  }else{
    res.redirect("/admin/")
  }
});
router.get('/details', function(req, res,next) {
  let user = req.session.user
  if(req.session.loggedIn){
    if(user.dep === 'admin'){
      let accid=req.query.id
      adminfitch.getDetail(accid).then((response)=>{
        res.render('admin/report_detail', { title: 'Accident Details', response, post:'Sys Admin',user});
      })
    }
  }else{
    res.redirect("/admin/")
  }
  
});
router.get('/reports', function(req, res,) {
  let user = req.session.user
  if(req.session.loggedIn){
    if(user.dep === 'admin'){
      adminfitch.getReports().then((reports)=>{
        res.render('admin/reports', { title: 'Reports', reports, post:'Sys Admin',user });
      })
    }
  }else{
    res.redirect("/admin/")
  }
});
router.get('/register', function(req, res, next) {
  let user = req.session.user
  if(req.session.loggedIn){
    if(user.dep === 'admin'){
      res.render('admin/register', { title: 'Register', post:'Sys Admin',user });
    }
  }else{
    res.redirect("/admin/")
  }
  
});
router.post('/register', function(req, res, next) {
  let user = req.session.user;
  if(req.session.loggedIn){
    if(user.dep ==='admin'){
      var reg = {"name":req.body.name,"phone":req.body.phone,"email":req.body.email,"dep":req.body.dep,"place":req.body.place,"password":req.body.password}
    adminfitch.regAgent(reg).then((responce)=>{
      res.write('<script>window.alert("Register successfully");window.location="/admin/register";</script>');
    })
    }
  }else{
    res.redirect("/admin/")
  }
  
});
router.get('/adminregister', function(req, res, next) {
  let user = req.session.user
  if(req.session.loggedIn){
    if(user.dep === 'admin'){
      res.render('admin/adregister', { title: 'Admin Register', post:'Sys Admin',user });
    }
  }else{
    res.redirect("/admin/")
  }
});
router.post('/adminregister', function(req, res, next) {
  let user = req.session.user;
  if(req.session.loggedIn){
    if(user.dep === 'admin'){
      var reg = {"name":req.body.name,"phone":req.body.phone,"email":req.body.email,"dep":"admin","password":req.body.password}
  adminfitch.regAdmin(reg).then((responce)=>{
    res.write(
      '<script>window.alert("Register successfully");window.location="/admin/adminregister";</script>'
    );
  })
    }
  }else{
    res.redirect("/admin/")
  }
  
});
router.get('/rerep', function(req, res,) {
  let user = req.session.user;
  if(req.session.loggedIn){
    if (user.dep == 'admin'){
      adminfitch.getReports().then((reports)=>{
        res.send(reports);
      })
    }else{
      res.send({})
    }
  }else{
    res.send({})
  }
});
router.get('/deletereport',(req,res)=>{
  let user = req.session.user;
  if(req.session.loggedIn){
    if (user.dep == 'admin'){
      let accid = req.query.id;
      adminfitch.deleteReport(accid).then((response)=>{
        res.write('<script>window.alert("Delete successfully");window.location="/admin/reports";</script>');
      })
    }
  }
})

module.exports = router;
