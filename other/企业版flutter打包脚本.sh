podTemplate(
    nodeUsageMode: "NORMAL",
    idleMinutes: 0,
    yaml: """
    spec:
      affinity:
        nodeAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 1
            preference:
              matchExpressions:
              - key: jenkins
                operator: In
                values:
                - slave
      dnsPolicy: None
      dnsConfig:
        nameservers:
        - 192.168.1.200
      hostAliases:
      - ip: "192.168.1.190"
        hostnames:
        - "git.wanshifu.com"
      - ip: "192.168.1.181"
        hostnames:
        - "nexus.wanshifu.com"
        - "yw-package.wanshifu.com"
      - ip: "192.168.1.11"
        hostnames:
        - "registry.wanshifu.com"
     """,
    containers: [
      containerTemplate(
            name: 'android',
            image: 'registry.wanshifu.com/library/builder-android-flutter',
            ttyEnabled: true,
            command: 'cat',
            resourceRequestCpu: "100m",
            resourceLimitCpu: "4000m",
            resourceRequestMemory: "100Mi",
            resourceLimitMemory: "8192Mi",
            envVars: [
            envVar(key: 'PUB_HOSTED_URL', value: 'https://pub.flutter-io.cn'),
            envVar(key: 'FLUTTER_STORAGE_BASE_URL', value: 'https://storage.flutter-io.cn')
            ]
         ),
     containerTemplate(
            name: 'jnlp',
            image: 'registry.wanshifu.com/library/jnlp-slave:alpine',
            args: '${computer.jnlpmac} ${computer.name}',
            command: '',
            resourceRequestCpu: "50m",
            resourceRequestMemory: "400Mi",
            resourceLimitMemory: "1536Mi"
         )
    ]
    ,volumes: [
         hostPathVolume(hostPath: '/root/work/jenkins', mountPath: '/home/jenkins'),
         hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock'),
         hostPathVolume(hostPath: '/root/.m2', mountPath: '/root/.m2'),
         hostPathVolume(hostPath: '/root/.android-flutter-user', mountPath: '/root/.android'),
         hostPathVolume(hostPath: '/root/.gradle-flutter-user', mountPath: '/root/.gradle'),
    ])
    
    
    {
      node {
         stage('checkout') {
    
                 echo 'checkout'
                 git branch: "${params.BRANCH}" , credentialsId: '61d44412-dd15-4dbb-83fc-02be02ec1f64', url: "http://git.wanshifu.com/user-android/WanshifuAndroid.git"
                   git branch: "${params.module}" , credentialsId: '61d44412-dd15-4dbb-83fc-02be02ec1f64', url: " http://git.wanshifu.com/user-mobile/wshifu_flutter_module.git"
    
         }
      }
    
      node (POD_LABEL) {
          stage('获取代码'){
               container('android'){
                    if (params.APK_ENV == 'assembleRelease'){
                        dir('code'){
                            retry(3){
                                checkout([$class: 'GitSCM',
                                            branches: [[name: "${params.BRANCH}"]],
                                            userRemoteConfigs: [[ credentialsId: '61d44412-dd15-4dbb-83fc-02be02ec1f64', url: '${git_address}']]
                                            ])
                                    }
                         }
                        dir('jiagu'){
                            retry(3){
                                checkout([$class: 'GitSCM',
                                            branches: [[name: 'master']],
                                            extensions: [
                                                [$class: 'SparseCheckoutPaths',  sparseCheckoutPaths:[[$class:'SparseCheckoutPath', path:'360jiagubao_linux_64.zip']]]
                                            ],
                                            userRemoteConfigs: [[ credentialsId: '61d44412-dd15-4dbb-83fc-02be02ec1f64', url: 'http://git.wanshifu.com/ops/builder-android.git']]
                                            ])
                                    }
                        }
    
                    } else {
                        dir('code'){
                            retry(3){
                                checkout([$class: 'GitSCM',
                                            branches: [[name: "${params.BRANCH}"]],
                                            userRemoteConfigs: [[ credentialsId: '61d44412-dd15-4dbb-83fc-02be02ec1f64', url: '${git_address}']]
                                            ])
                                    }
                         }
    
                    }
    
               }
          }
    
          stage('拉取子module 的代码'){
                container('android'){
                  dir('code') {
                    sh '''
                        git config --global user.email "wuzhibei@wshifu.com"
                        git config --global user.name "wuzhibei"
                        echo "http://yunwei:Yunwei%402022@git.wanshifu.com" >/root/.git-credentials
                        git config --global credential.helper store
                    '''
                    sh 'git submodule update --init --recursive'
                    sh 'git submodule foreach git checkout ${module}'
                    sh 'git submodule foreach git pull origin'
                  }
                }
          }
    
          stage('构建打包'){
                container('android'){
    
                    dir('code'){
    
                      sh 'echo -e "\norg.gradle.java.home=/jdk-11.0.13/" >> ./gradle.properties'
                    }
    
                    dir('code/wshifu_flutter_module'){
                      sh 'flutter --version'
                      sh 'flutter pub get'
                    }
    
                    if (params.APK_ENV == 'buildTinkerPatchRelease'){
                        unstash 'Patch'
                        sh 'unzip -d code Patch'
                        dir('code'){
                              sh 'chmod +x gradlew && rm -r -f WshifuAppAndroid/build  && mv archive/WshifuAppAndroid/build  ./WshifuAppAndroid/'
                              sh 'pwd && ls -l '
                              sh 'sh ./gradlew ${APK_ENV}  -Ptarget=lib/main_release.dart'
                              archiveArtifacts artifacts: 'WshifuAppAndroid/build/outputs/patch/release/*.apk',
                              fingerprint: true
                        } 
                    } else if(params.APK_ENV == 'packageReleaseJiaGu360') {
                        dir('code'){
                            sh 'ls -l ./'  
                            sh 'chmod +x gradlew && rm -r -f WshifuAppAndroid/build'
                            sh 'pwd && ls -l '
                            sh './gradlew clean ${APK_ENV} -Ptarget=lib/main_release.dart'
                            archiveArtifacts artifacts: 'WshifuAppAndroid/build/bakApk/WshifuAppAndroid**/*.apk,WshifuAppAndroid/build/bakApk/WshifuAppAndroid**/**mapping.txt,WshifuAppAndroid/build/bakApk/WshifuAppAndroid**/**R.txt',
                            fingerprint: true
                      } 
    
                    } else if(params.APK_ENV == 'packageDevWsf') {
                      dir('code'){
                          sh 'chmod +x gradlew && rm -r -f WshifuAppAndroid/build/bakApk'
                          sh 'pwd && ls -l'
                          sh './gradlew ${APK_ENV} -Pbuild_env=dev  -Ptarget=lib/main_dev.dart'
                          archiveArtifacts artifacts: 'WshifuAppAndroid/build/bakApk/WshifuAppAndroid**/*.apk,WshifuAppAndroid/build/bakApk/WshifuAppAndroid**/**mapping.txt,WshifuAppAndroid/build/bakApk/WshifuAppAndroid**/**R.txt',
                          fingerprint: true
                       }
    
                    } else if(params.APK_ENV == 'assembleDebug') {
                        dir('code'){
                          sh 'chmod +x gradlew && rm -r -f WshifuAppAndroid/build/bakApk'
                          sh 'pwd && ls -l'
                          sh './gradlew ${APK_ENV}  -Pbuild_env=test -Ptarget=lib/main_test.dart'
                          archiveArtifacts artifacts: 'WshifuAppAndroid/build/bakApk/WshifuAppAndroid**/*.apk,WshifuAppAndroid/build/bakApk/WshifuAppAndroid**/**mapping.txt,WshifuAppAndroid/build/bakApk/WshifuAppAndroid**/**R.txt',
                          fingerprint: true
                       }
                    } else {
                       dir('code'){
                          sh './gradlew  ${APK_ENV}  -Ptarget=lib/main_release.dart'
                          archiveArtifacts artifacts: 'WshifuAppAndroid/build/bakApk/WshifuAppAndroid**/*.apk,WshifuAppAndroid/build/bakApk/WshifuAppAndroid**/**mapping.txt,WshifuAppAndroid/build/bakApk/WshifuAppAndroid**/**R.txt',
                          fingerprint: true
                       }
                    }
    
                }
          }
    
          stage('加固二维码/二维码'){
                container('android'){
                    if (params.APK_ENV == 'assembleRelease'){
                        stage('apk加固'){
                            dir('jiagu'){
                                sh '''
                                    unzip 360jiagubao_linux_64.zip
                                    cp ../code/WshifuAppAndroid/wsf_user.keystore .
                                    java -jar jiagu/jiagu.jar -login develop@wshifu.com Xiaoyi001
                                    java -jar jiagu/jiagu.jar -importsign wsf_user.keystore nVRJGKzMhYxw7sxW7nYQpvGYj4f3ffc8 wanshifu.master nVRJGKzMhYxw7sxW7nYQpvGYj4f3ffc8
                                    java -jar jiagu/jiagu.jar -showsign   // 展示已配置的签名文件
                                    java -jar jiagu/jiagu.jar -jiagu ../code/WshifuAppAndroid/build/bakApk/WshifuAppAndroid**/*.apk ./ -autosign
                                '''
                                archiveArtifacts artifacts: '*.apk'
                                fingerprint: true
                            }
                        }
                    }
                 }
          }
    
          stage('上传及/二维码'){
              container('android'){
                    if (params.APK_ENV == 'assembleRelease'){
                        stage('Pro 上传'){
                            dir('jiagu'){
                                sh '''
                                    URL_APK=`find *jiagu_sign.apk`
                                    branch=`env|grep BRANCH`
                                    env=`env|grep APK_ENV`
                                    package_env=`if [[ $env  =~ Dev ]];then echo "开发环境";elif [[ $env =~ Debug ]];then echo "测试环境";elif [[ $env =~ JiaGu ]];then echo "线上多渠道加固包";else echo "线上环境";fi`
    
                                    qrencode -o qrcode.png -s 8 http://192.168.1.71:30080/job/${JOB_NAME}/${BUILD_NUMBER}/artifact/${URL_APK}
                                    QR_URL=`curl -F "file=@${WORKSPACE}/jiagu/${URL_APK}" -F "updateDescription=分支名称：${branch}\\n打包环境: ${package_env}" -F "uKey=26e17e3f45b86287a2dd8f49ef488f40" -F "_api_key=b3ac9df0f0b4f1049f4cf2b05fed7041" https://qiniu-storage.pgyer.com/apiv1/app/upload | jq`
                                    appShortcutUrl=`echo ${QR_URL}|jq -r .data.appShortcutUrl`
                                    appVersion=`echo ${QR_URL}|jq -r .data.appVersion`
                                    appName=`echo ${QR_URL}|jq -r .data.appName`
                                    appVersion=`echo ${QR_URL}|jq -r .data.appVersion`
                                    appUpdated=`echo ${QR_URL}|jq -r .data.appUpdated`
    
                                    updateDescription=`echo ${QR_URL}|jq -r .data.appUpdateDescription`
                                    
                                    curl -d '{
                                        "msg_type": "text",
                                        "content": {
                                            "text": "打包成功: 地址 https://www.pgyer.com/'"${appShortcutUrl}"'\\n应用名称:'"${appName}"'\\n版本号：'"${appVersion}"'\\n应用更新时间:'"${appUpdated}"'\\n分支名称：'"${branch}"'\\n打包环境: '"${package_env}"' \\n更新说明:'"${updateDescription}"'"
                                        }
                                    } ' -H "Content-Type: application/json" "https://open.feishu.cn/open-apis/bot/v2/hook/23e3bbf7-c9ca-44de-b7c5-a3964db81184"
    
                                '''
    
                                archiveArtifacts artifacts: 'qrcode.png',
                                fingerprint: true
                                currentBuild.description = "<img style='-webkit-user-select:none;cursor:zoom-in;' src='http://192.168.1.71:30080/job/${JOB_NAME}/${BUILD_NUMBER}/artifact/qrcode.png' width='307' height='307'>"
    
                            }
                        }
                      } else if (params.APK_ENV == 'buildTinkerPatchRelease'){
                        sh '''
                            echo "ok"
                           '''
                      } else if(params.APK_ENV == 'packageReleaseJiaGu360') {
                          stage('生成二维码'){
                            dir('code'){
                                withCredentials([usernamePassword(credentialsId: "cup", passwordVariable: 'password', usernameVariable: 'username')]) {
                                sh '''
                                    URL_APK=`find WshifuAppAndroid/build/bakApk/WshifuAppAndroid**/*jiagu_sign.apk`
                                    branch=`env|grep BRANCH`
                                    env=`env|grep APK_ENV`
                                    package_env=`if [[ $env  =~ Dev ]];then echo "开发环境";elif [[ $env =~ Debug ]];then echo "测试环境";elif [[ $env =~ JiaGu ]];then echo "线上多渠道加固包";else echo "线上环境";fi`
    
                                    qrencode -o qrcode.png -s 8 http://192.168.1.71:30080/job/${JOB_NAME}/${BUILD_NUMBER}/artifact/${URL_APK}
                                    QR_URL=`curl -F "file=@${WORKSPACE}/code/${URL_APK}" -F "updateDescription=分支名称：${branch}\\n打包环境: ${package_env}" -F "uKey=26e17e3f45b86287a2dd8f49ef488f40" -F "_api_key=b3ac9df0f0b4f1049f4cf2b05fed7041" https://qiniu-storage.pgyer.com/apiv1/app/upload | jq`
                                    appShortcutUrl=`echo ${QR_URL}|jq -r .data.appShortcutUrl`
                                    appVersion=`echo ${QR_URL}|jq -r .data.appVersion`
                                    appName=`echo ${QR_URL}|jq -r .data.appName`
                                    appVersion=`echo ${QR_URL}|jq -r .data.appVersion`
                                    appUpdated=`echo ${QR_URL}|jq -r .data.appUpdated`
    
                                    updateDescription=`echo ${QR_URL}|jq -r .data.appUpdateDescription`
                                
                                      TAG=`if [[ $tag  = yes ]];then 
                                      git config --global user.email "wuzhibei@wshifu.com"
                                      git config --global user.name "wuzhibei"
                                      echo "http://yunwei:Yunwei%402022@git.wanshifu.com" >/root/.git-credentials
                                      git config --global credential.helper store
                                      git config --list &&
                                      git tag -a $TAGS -m '构建成功,输出版本' &&
                                      ${password} | git push origin $TAGS  ; fi`
                                      
                                      MASTER=`if [[ $master  = yes ]];then 
                                      git stash 
                                      git checkout --track origin/master
                                      git merge dev  
                                      ${password} | git push origin master ; fi`                              
                                      
                                      BACKUP=`if [[ $backup = yes ]];then
                                      mkdir -p /data/gitpush/
                                      cp WshifuAppAndroid/build/bakApk/WshifuAppAndroid**/WshifuAppAndroid-release.apk WshifuAppAndroid/build/bakApk/WshifuAppAndroid**/**mapping.txt  WshifuAppAndroid/build/bakApk/WshifuAppAndroid**/**R.txt /data/gitpush/
                                      zip archive.zip ./*
                                      mv archive.zip  /data/gitpush/
                                      cd /data/gitpush/
                                      git clone http://git.wanshifu.com/user-mobile/common-development-plan.git
                                      cd common-development-plan
                                      mkdir android_release_备份/$NAME
                                      mv  ../archive.zip android_release_备份/$NAME
                                      git add .
                                      git commit -m "构建完成"
                                      ${password} | git push origin master ; fi`
                                      
                                    curl -d '{
                                        "msg_type": "text",
                                        "content": {
                                            "text": "打包成功: 地址 https://www.pgyer.com/'"${appShortcutUrl}"'\\n应用名称:'"${appName}"'\\n版本号：'"${appVersion}"'\\n应用更新时间:'"${appUpdated}"'\\n分支名称：'"${branch}"'\\n打包环境: '"${package_env}"' \\n更新说明:'"${updateDescription}"'"
                                        }
                                    } ' -H "Content-Type: application/json" "https://open.feishu.cn/open-apis/bot/v2/hook/23e3bbf7-c9ca-44de-b7c5-a3964db81184"
                                '''
    
                                archiveArtifacts artifacts: 'qrcode.png',
                                fingerprint: true
                                currentBuild.description = "<img style='-webkit-user-select:none;cursor:zoom-in;' src='http://192.168.1.71:30080/job/${JOB_NAME}/${BUILD_NUMBER}/artifact/qrcode.png' width='307' height='307'>"
                             }
                            }
                          }
                      } else {
                          stage('生成二维码'){
                              dir('code'){
                                  sh '''
                                      URL_APK=`find WshifuAppAndroid/build/bakApk/WshifuAppAndroid**/*.apk`
                                      branch=`env|grep BRANCH`
                                      env=`env|grep APK_ENV`
                                      package_env=`if [[ $env  =~ Dev ]];then echo "开发环境";elif [[ $env =~ Debug ]];then echo "测试环境";else echo "线上环境";fi`
    
                                      qrencode -o qrcode.png -s 8 http://192.168.1.71:30080/job/${JOB_NAME}/${BUILD_NUMBER}/artifact/${URL_APK}
                                      QR_URL=`curl -F "file=@${WORKSPACE}/code/${URL_APK}" -F "updateDescription=分支名称：${branch}\\n打包环境: ${package_env}" -F "uKey=26e17e3f45b86287a2dd8f49ef488f40" -F "_api_key=b3ac9df0f0b4f1049f4cf2b05fed7041" https://qiniu-storage.pgyer.com/apiv1/app/upload | jq`
                                      appShortcutUrl=`echo ${QR_URL}|jq -r .data.appShortcutUrl`
                                      appVersion=`echo ${QR_URL}|jq -r .data.appVersion`
                                      appName=`echo ${QR_URL}|jq -r .data.appName`
                                      appVersion=`echo ${QR_URL}|jq -r .data.appVersion`
                                      appUpdated=`echo ${QR_URL}|jq -r .data.appUpdated`
    
                                      updateDescription=`echo ${QR_URL}|jq -r .data.appUpdateDescription`
    

                                    curl -d '{
                                        "msg_type": "text",
                                        "content": {
                                            "text": "打包成功: 地址 https://www.pgyer.com/'"${appShortcutUrl}"'\\n应用名称:'"${appName}"'\\n版本号：'"${appVersion}"'\\n应用更新时间:'"${appUpdated}"'\\n分支名称：'"${branch}"'\\n打包环境: '"${package_env}"' \\n更新说明:'"${updateDescription}"'"
                                        }
                                    } ' -H "Content-Type: application/json" "https://open.feishu.cn/open-apis/bot/v2/hook/23e3bbf7-c9ca-44de-b7c5-a3964db81184"
                                  '''
    
                                  archiveArtifacts artifacts: 'qrcode.png',
                                  fingerprint: true
                                  currentBuild.description = "<img style='-webkit-user-select:none;cursor:zoom-in;' src='http://192.168.1.71:30080/job/${JOB_NAME}/${BUILD_NUMBER}/artifact/qrcode.png' width='307' height='307'>"
                              }
                          }
                      }
              }
          }
      }
      
    }