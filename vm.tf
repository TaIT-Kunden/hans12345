from flask import Flask

from github import Auth
from github import Github
import requests
import os
import base64

#access_token=os.environ.get("access_token")
# using an access token

manifest_template_file='vm.tf'
app = Flask(__name__)

payload={'provider':'Exoscale','product':'vm','vm-name':'host01','customer':'hans12345','id':'1'}

@app.route('/health', methods=["GET"])
def health():
    return "<p>Healthy</p>"

@app.route('/')
def main():
    org=get_orga()
    e=create_customer(org)
    return '',e
    
def get_orga():
    #access_token='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'
    #access_token='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'
    access_token='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'
    gitauth = Auth.Token(access_token)
    g = Github(auth=gitauth)
    return g.get_organization('TaIT-Kunden')
    
def create_product_manifest(org):
    status=200
    manifest = open(manifest_template_file, "r")
    #print(manifest.read())
    file_content=str(manifest.read())

    #manifest='initialasdfasdf'
    #print(org.url)
    repo=org.get_repo(payload['customer'])
    #print(repo)
    try:
        #repo.update_file("vm11.tf", "updating file", 'test121212', file.sha, branch="main")
        repo.create_file(manifest_template_file, "initial file",file_content, branch="main")
    except Exception as e:
        #return e.status
        try:
            file = repo.get_contents("/"+manifest_template_file)
            repo.update_file(manifest_template_file, "updating file", file_content, file.sha, branch="main")
        except Exception as e:
            print(e)
            status=e.status
    return status

def create1_customer(org):
    print(org)
    create_customer_repo(org)

def create_customer(org):
    e=create_customer_repo(org)
  
    if e == 422:
        print('error creating repo')
        return 500
    e=create_product_manifest(org)
    #print(e)
    if e == 422:
        print('error creating file')
        return 500
    return(e)
    #create_product_manifest(org)
    

@app.route('/check')
def create_customer_repo(org):
    #print(dir(org))
    #print(payload)
    print(org)
    try:
       
        repo = org.create_repo(payload['customer'])
    except Exception as e:
        
        if e.data['message'] in 'Repository creation failed.':
            pass
        else:
            return e.status
            raise
            
    #create_product_manifest(org)

        #return(str(e.status)+' Repo already exists',501)
        #print(e)
        
        #return {"msg": "something went wrong"}, e.status
        #return('e')
        
        #print(e)
        #return('e')
        

    #for i in g.get_user().get_orgs():
    #    print(i)
    #new_repo = g.get_user().create_repo("TaIT-CloudSolutions/hans2.git")
    #repo = g.get_repo("TaIT-Kunden/hans")


    #contents = repo.get_contents("README.md")
    #repo.update_file(contents.path, "more tests", "more tests", contents.sha, branch="main")
    #repo.delete_file(contents.path, "remove test", contents.sha, branch="test")
 
    #customer_entry=payload.customer
    #repo.create_file(payload['customer']+"/main.tf", "test1234", text, branch="main")
    #print(dir(repo))
    #repo.create_file('test.txt','init commit',contents.content)
    #print(dir(contents))
    #print(contents.content)
    #base64_bytes = contents.content.encode('ascii')
    #message_bytes = base64.b64decode(base64_bytes)
    #message = message_bytes.decode('ascii') 
    #print(message)

    #repo.create_file("test.txt", "5b584cf6d32d960bb7bee8ce94f161d939aec377", "5b584cf6d32d960bb7bee8ce94f161d939aec377", branch="main")
 
    return 'ok'


   



    


def check_for_customer():
    pass


@app.route('/test')
def check_for_repo():
    access_token='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'
    gitauth = Auth.Token(access_token)
    g = Github(auth=gitauth)
    for repo in g.get_user().get_repos():
        if repo.name in 'middleware-product-vm1':
            check_repo=repo.name
        else:
            check_repo='repo is missing'

        #    print('ok')

    return check_repo
        #repo.edit(has_wiki=False)
    # to see all the available attributes and methods

if __name__ == '__main__':

    app.run(host='0.0.0.0',port='5001')  
    

