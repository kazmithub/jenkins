#!/usr/bin/env groovy

taskDefImage= 'nginx'

node {
  def last_commit= sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()

  stage 'Checkout'
  git 'https://github.com/kazmithub/jenkins'
 
  stage 'Docker build'
  docker.build('demo')

  stage 'Docker push'
  docker.withRegistry('https://853219876644.dkr.ecr.us-west-2.amazonaws.com', 'ecr:us-west-2:demo-ecr-credentials') {
    docker.image('demo').push("${last_commit}")
    // docker.image('demo').push('new')
  }
  
  stage('Deploy') {
       // Override image field in taskdef file
       sh "sed -i 's|{{image}}|${docker_repo_uri}:${last_commit}|' taskdef.json"
    
       taskDefImage="${docker_repo_uri}:${last_commit}"

       // sh "sed -i 's|{{image}}|${docker_repo_uri}|' taskdef.json"
       // sh "docker push ${docker_repo_uri}:"
       // Create a new task definition revision
       sh "aws ecs register-task-definition --execution-role-arn arn:aws:iam::853219876644:role/Jenkins --cli-input-json file://taskdef.json --region ${region}"
       // Update service
       // sh "aws ecs update-service --cluster ${cluster} --service v1-taskDefinition --region ${region}"  
       // sh "aws cloudformation update-stack --stack-name stackEc2 --region us-west-2 --template-url https://ahsan-tf.s3-us-west-2.amazonaws.com/cfn.yaml
       
       def foo = sh "aws ecs list-services --region ${region} --cluster prod1-WebServer-Cluster | cut -d / -f 2"
       echo "${foo}"
     // withAWS(region:'us-west-2') {
      //  def outputs = cfnUpdate(stack:'stackEcs',params:['createNewService': "${createNewService}",'serviceName': "${serviceName}",'taskDefImage': "${taskDefImage}",'networkMode': "${networkMode}", 'albSg': "${albSg}", 'subnet1': "${subnet1}", 'subnet2': "${subnet2}", 'vpc': "${vpc}", 'cluster': "${cluster}", 'roleArn': "${roleArn}", 'desiredCount': "${desiredCount}"], url:'https://ahsan-tf.s3-us-west-2.amazonaws.com/alb.yaml')
         
  //  }
  }
}
