var db=require('./db_connection');
var objectId = require('mongodb').ObjectID


module.exports={
    getReports:()=>{
        return new Promise(async(resolve,reject)=>{
            let reports=await db.get().collection('accreport').aggregate([
                {
                    "$sort":{"_id":-1}
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
            ]).toArray()
            resolve(reports)
        })
    },
    getDetail:(accid)=>{
        return new Promise(async(resolve,reject)=>{
            let iid = objectId(accid)
            let response=await db.get().collection('accreport').aggregate([
                {
                    '$match': {
                      '_id': iid
                    }
                  }, { "$lookup": {
                    "let": { "userObjId": { "$toObjectId": "$userid" } },
                    "from": "user",
                    "pipeline": [
                      { "$match": { "$expr": { "$eq": [ "$_id", "$$userObjId" ] } } }
                    ],
                    "as": "user"
                  }}
            ]).toArray()
            resolve(response)
        })
    },
    regAgent:(reg)=>{
        return new Promise(async(resolve,reject)=>{
            let responce = await db.get().collection('agent').insertOne(reg);
            resolve(responce)
        })
    },
    regAdmin:(reg)=>{
        return new Promise(async(resolve,reject)=>{
            let responce = await db.get().collection('admin').insertOne(reg);
            resolve(responce)
        })
    },
    adminLogin:(loginData)=>{
        return new Promise(async(resolve,reject)=>{
            let user = await db.get().collection('admin').findOne({email:loginData.email});
            if(user){
                if(user.password == loginData.pass){
                    resolve({"status":"login","userid":user._id,"name":user.name,"phone":user.phone,"email":user.email,"dep":user.dep,"pass":user.password,})
                }else{
                    resolve({"status":"errpass"})
                }
            }else{
                resolve({"status":"nouser"})
            }
            
        })
    },
    deleteReport:(accid)=>{
        return new Promise((resolve,reject)=>{
            let id = objectId(accid);
            db.get().collection('accreport').removeOne({_id:id}).then((response)=>{
                resolve(response)
            })
        })
    }
    
}