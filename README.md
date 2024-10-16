# Kubernetes Assignment

## New Project - Crud REST API MVP

You are Joey, a junior infra engineer who has just joined a new project. Your project has developed an MVP for a CRUD REST API. Your project uses `docker-compose` to manage the deployment and operation of services. However, with the increase in user volume, you have found that the deployment method of `docker-compose` can no longer meet your needs. The team has decided to use `kubernetes` to replace `docker-compose` in order to improve the scalability and reliability of the service.

Your tech lead is Holly, an experienced devops expert. She is responsible for guiding you and other newcomers on how to use `kubernetes`. She has provided you with a `docker-compose` configuration file for the project along with the application source code. She has instructed you to refer to it to run the services in the Kubernetes cluster. This project is an `api` service developed using the `golang` framework, responsible for handling user management requests as a backend application, and it uses `postgres` as the database. She also informed you that the `docker-compose` file was written by a former engineer who has since left and although it works Holly believes moving to Kubernetes may allow us to make improvements to the solution.

## App Usage

The REST API is extremely basic, there's no data validation or paramatisation from a security stand point as it still is an MVP. It currently provides basic CRUD capabilities for user data. To understand what data we can send the REST API you need to know the 'user' class which is defined as follows (Id is generated by the database):

```
type User struct {
	ID    int    `json:"id"`
	Name  string `json:"name"`
	Email string `json:"email"`
}
```

Here are the REST API routes:

```
	router.HandleFunc("/users", getUsers(db)).Methods("GET")
	router.HandleFunc("/users/{id}", getUser(db)).Methods("GET")
	router.HandleFunc("/users", createUser(db)).Methods("POST")
	router.HandleFunc("/users/{id}", updateUser(db)).Methods("PUT")
	router.HandleFunc("/users/{id}", deleteUser(db)).Methods("DELETE")
```

Knowing this information we can now use curl to get a list of all users (the array will be empty to start):

```
curl -X GET http://localhost:8000/users
```

We can also use curl to add a new user using the REST API:

```
curl -X POST http://localhost:8000/users -d '{"name":"John Doe", "email":"jdoe@example.com"}' -H "Content-Type: application/json"
```

This should return a json object with an Id along with the data passed in. This indicates that the command worked. You can now either run a curl command or access the web browser at the address `http://localhost:8000/users` to confirm the user has been added.

You should be able to test out any of the REST API routes with this application. For example you can delete a user with the following curl cmd:

```
curl -X DELETE http://localhost:8000/users/1 -H "Content-Type: application/json"
```

## Pre-requisites

You should have Rancher started with the current version of kubernetes active.

## Testing the App in Docker-Compose

Holly has advised that before you start the task of migrating the project to Kubernetes she recommends testing it out in Docker so you understand how it works. You can run the following to bring up the solution:

```
docker-compose up
```

Now you should be able to access `http://localhost:8000/users` in a web browser and it should return `[]` if it's the first time you've accessed it. Now you can test the API using the curl commands previously shared above. Once you are finished testing it out we recommend running the following to properly decommission the containers:

```
docker-compose down
```

## Task Requirements

Holly is happy that you have a good understanding of the solution and has now provided you with the following requirements:

1. You should create a single yaml file called `deployment.yaml` for the deployment of all Kubernetes resources but she would like you to add the resources to this file and test the deployment in logical steps to make it easier to troubleshoot as the solution becomes more complex.

2. Add a `secret` resource as the first resource in `deployment.yaml`. This is for the database password. Please note it needs to be of type `Opaque` and the value is base64 encoded before adding it to the K8s secret as a value. Holly has advised that at a later stage `deployment.yaml` will be generated during the CI/CD process therefore the secret value can be retrieved from an external secret vault and injected when creating the file so that it's not stored in the code but for now she just wants to see if it will work in Kubernetes.

3. She would like you to create a `deployment` resource for the postgres database that has the same environment variables as per the docker-compose file. The database password should come from the kubernetes secret in the previous step. Once again deploy it to ensure everything works before proceeding (check the logs of the pod to confirm this).

4. Holly now would like you to create a `service` of type ClusterIP for the postgres database `deployment` resource and expose the same container port in the service (this should be port 5432 for postgres). Once again deploy it to ensure everything works before proceeding.

5. Holly is pleased with your progress as you've now showed her that the database is up and running, she's keen to see the backend API communicate with this database. She would like you to create a new `deployment` resources for the backend API. As you've already run docker-compose earlier to test the solution you should already have an image called `final_assignment-backend` available locally (you can run `docker images` to verify this). Assuming it is there then you can specify the following in your deployment as it will use the local image as this image does not exist in Docker Hub:

```
imagePullPolicy: Never
image: final_assignment-backend
```

Once again you'll need to add similar environment variables as per the docker-compose file and the database password should come from the kubernetes secret. Once again deploy it to ensure everything works before proceeding.

6. Holly would now like you to add a `service` of type ClusterIP for the backend API `deployment` resource, it should expose the same port as the container (8000). Deploy everything again and ensure there are no errors in the logs.

7. Holly now believe's you should be able to test the app's REST API, she's super excited :-) She's advised that you can use a kubectl port forwarding cmd to gain access to it:

```
kubectl port-forward service/backend-api 8000:8000
```

She hopes you can interact with the REST API just like you have done when you ran the solution with docker-compose. If it doesn't work then you should review any errors or logs and troubleshoot it before proceeding.

8. Holly has spotted two issues that she wishes you to resolve. She would like the whole solution to be in a dedicated namespace called crud-app. She recommends implementing this first and testing it out. Please note all kubectl commands operate in the scope of the default namespace so once you start working in a named workspace then you should add an extra flag to your commands (for example: `kubectl get pods -n crud-app`).

9. Lastly she would like the data to be persistent, currently if you delete the resources the data is deleted too. She believes you can create a `PersistentVolume` and a `PersistentVolumeClaim` and associate it with a mounted volume in the postgres database `deployment` resource. She is happy for you to use a local host path to store the data outside of the Kubernetes cluster. Once deployed without any errors Holly would like you to verify it works by testing that data persists after deleteing and recreating all the Kubernetes resources.

10. Holly's had a thought, she believe's that having all resources in a single fle `deployment.yaml` is not very scalable or maintainable, she would like you to split it up into smaller logical files, perhaps one for the namespace, one for the backend API and one for the database. You can still apply kubernetes changes with one command but instead you reference the folder rather than the file.
