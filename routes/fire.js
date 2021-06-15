const { response } = require('express');
var express = require('express');
var router = express.Router();
const fireFitch = require('../sett/fireFitch')

/* GET users listing. */

router.get('/', function(req, res) {
  let user = req.session.user;
  if(req.session.loggedIn){
    if (user.dep == 'fire'){
      res.render('fire/dindex', { title: 'Dashboard', post:'Fire',user });
    }else{
      res.redirect('/login')
    }
  }else{
    res.redirect('/login')
  }
});
router.get('/details?', function(req, res,next) {
  let user = req.session.user;
  if(req.session.loggedIn){
    if (user.dep == 'fire'){
      let accid=req.query.id
      fireFitch.getDetail(accid).then((response)=>{
        fireFitch.fireView(accid);
    console.log(response)
    res.render('fire/report_detail', { title: 'Accident Details', response, post:'Fire',user });
  })
    }else{
      res.redirect('/login')
    }
  }else{
    res.redirect('/login')
  }
});
router.get('/accept', function(req, res,next) {
  let user = req.session.user;
  if(req.session.loggedIn){
    if (user.dep == 'fire'){
      let accid=req.query.id
      fireFitch.fireAccept(accid).then((response)=>{
        console.log(response)
        res.redirect('/fire/reports');
      })
    }else{
      res.redirect('/login')
    }
  }else{
    res.redirect('/login')
  }
});
router.get('/reports', function(req, res,) {
  let user = req.session.user;
  if(req.session.loggedIn){
    if (user.dep == 'fire'){
      fireFitch.getReports().then((reports)=>{
        console.log(reports)
        res.render('fire/reports', { title: 'Reports', reports, post:'Fire',user });
      })
    }else{
      res.redirect('/login')
    }
  }else{
    res.redirect('/login')
  }
});
router.get('/rerep', function(req, res,) {
  let user = req.session.user;
  if(req.session.loggedIn){
    if (user.dep == 'fire'){
      fireFitch.getReports().then((reports)=>{
        console.log(reports)
        res.send(reports);
      })
    }else{
      res.redirect('/login')
    }
  }else{
    res.redirect('/login')
  }
});

module.exports = router;
