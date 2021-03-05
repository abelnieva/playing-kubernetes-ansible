#!/usr/bin/python
import json 
import os


os.putenv("ARM_SUBSCRIPTION_ID", "cf3e9f6d-fac4-4695-94a8-8d19dd9e753e")


try:
    f = open('azcreds.json',) 
    data = json.load(f) 
   
    for i in data: 
        if i == "tenant":
            os.putenv("ARM_TENANT_ID", data[i])
        if i == "password":
            os.putenv("ARM_CLIENT_SECRET", data[i])
        if i == "appId":
            os.putenv("ARM_CLIENT_ID", data[i])
        
    os.system('bash')
    # Closing file 
    f.close() 
except FileNotFoundError:
    print( "azcreds.json no existe")


