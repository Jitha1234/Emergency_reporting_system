var db = require('./db_connection')
var objectId = require('mongodb').ObjectID
module.exports={
    userReg:(user,callback)=>{
        db.get().collection('user').findOne({email:user.email}).then((extuser)=>{
            if(extuser){callback({status:'existuser'});}
            else {
                db.get().collection('user').insertOne(user).then((data)=>{
                    callback({status:'reguser'});
                })
            }
        });
    },
    userLogin:(user,callback)=>{
        db.get().collection('user').findOne({email:user.email}).then((extuser)=>{
            if(extuser){
                db.get().collection('user').findOne({email:user.email,password:user.password}).then((match)=>{
                    if(match){
                        callback({status:'login',
                        id:match._id,
                        firstname:match.firstname,
                        lastname:match.lastname,
                        email:match.email,
                        phone:match.phone,
                        password:match.password});
                    }
                    else callback({status:'failed'});
                })
            }
            else {
                callback({status:'nouser'});
            }
        });
    },
    accUpload:(report,callback)=>{
        db.get().collection('accreport').insertOne(report).then((data)=>{
                    callback(data);
                })
        
    },
    userUpdate:(user,callback)=>{
        let __id = objectId(user.id)
        db.get().collection('user').updateOne({_id:__id}, {$set: {'firstname':user.fname,'lastname':user.lname,'email':user.email,'phone':user.phone}},{new: true},(err, res)=>{
            if (err) throw err;
            if(res){
                db.get().collection('user').findOne({_id:__id},(err,res)=>{
                    let ans ={fname:res.firstname,lname:res.lastname,email:res.email,phone:res.phone}
                    callback(ans)
                })
            }
        })
    },
    passUpdate:(user,callback)=>{
        let __id = objectId(user.id)
        db.get().collection('user').updateOne({_id:__id}, {$set: {'password':user.pass}},{new: true},(err, res)=>{
            if (err) throw err;
            if(res){
                db.get().collection('user').findOne({_id:__id},(err,res)=>{
                    let ans ={pass:res.password,}
                    callback(ans)
                })
            }
        })
    },
    getReports:(user,callback)=>{
        idd=user.id
        db.get().collection('accreport').aggregate([
            {
                "$sort":{"_id":-1}
            },
            {
                "$match":{'userid':idd}
            },
            {
                "$lookup": {
                    "from": "user",
                    "let": { "userObjId": { "$toObjectId": "$userid" } },
                    "pipeline": [
                        { "$match": { "$expr": { "$eq": [ "$_id", "$$userObjId" ] } }}
                    ],
                    "as": "user"
                },
            }
        ]).toArray().then((data)=>{
            callback(data)
        })
    },
    getRepDetail:(rep,callback)=>{
        
        accid=rep.id
        let __id = objectId(accid);
        db.get().collection('accreport').findOne({_id:__id},(err,res)=>{
            
            callback(res)
        }); 
    },
}