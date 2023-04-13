# background

Background IOS service

## Getting Started

1. First of all you need add "Backgoround fetch", "Background processing" capabilities in your project (Runner->Singin & Capabilities->Background Modes)
2. Then in main Info.plist Permitted background task scheduler identifiers add items with identifiers:
    - For refresh tasks - com.vergo.iosBackground.refresh.YOUR_TASK_NAME
    - For processing tasks - com.vergo.iosBackground.ProcessingTask.YOUR_TASK_NAME
3. Add the following code to your project Runner->AppDelegate.swift :
    ```import background```  - after import Flutter
    ```
    let bgRefreshTasksIdentifiers = ["com.vergo.iosBackground.refresh.testRefresh.YOUR_TASK_NAME"]
    let bgProcessingTasksIdentifiers = ["com.vergo.iosBackground.ProcessingTask.testProcessing.YOUR_TASK_NAME"]
    
    BackgroundPlugin().saveIdentifires(bgProcessingTasksIdentifiers: bgProcessingTasksIdentifiers, bgRefreshTasksIdentifiers: bgRefreshTasksIdentifiers)
    ```
    Before GeneratedPluginRegistrant.register(with: self) line
    You can add as much as you want tasks, BUT TWO IMPORTANT THINGS:
        1. Identifiers witch you add in AppDelegate must match with identifiers in Info.plist
        2. YOUR_TASK_NAME - mast match with task names, witch you create in your code 


## Debug
# Debug Refresh task
1. You need add breakpoint after ```try BGTaskScheduler.shared.submit(request)``` line
2. Then after your app has been paused execute the following comand in Xcode command line
```e -l objc -- (void)[[BGTaskScheduler sharedScheduler _simulateLaunchForTaskWithIdentifier:@".YOUR_TASK_IDENTIFIER"]```
3. Resume back your app
4. Well done, your task should be executed


This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

