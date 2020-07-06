import ballerina/log;
import ballerina/http;
import ballerina/kubernetes;

@kubernetes:Service {
    name : "todos",
    serviceType: "LoadBalancer"
}
listener http:Listener todosListener = new(9090);

@kubernetes:Deployment {
    name : "todos",
    image : "dunithd.azurecr.io/todo-service:latest"
}
@http:ServiceConfig {
    basePath: "/todos"
}
service TodoService on todosListener {

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/" 
    }
    resource function getAllTodos(http:Caller caller, http:Request request) {
        //return some mock Todo objects as a JSON array
        json todos = [
            {
                "id" : 1,
                "name" : "Create the Docker image",
                "status" : "OPEN"
            },
            {
                "id" : 2,
                "name" : "Create AKS Cluster",
                "status" : "OPEN"
            },
            {
                "id" : 3,
                "name" : "Configure Ingress",
                "status" : "OPEN"
            }
        ];
        //respond to the caller
        var responseResult = caller->respond(todos);
        if (responseResult is error) {
            log:printError("Error responding back to client.", responseResult);
        }
    }
}
