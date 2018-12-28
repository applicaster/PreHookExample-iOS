# PreHookExample-iOS
This document describes how to start test env for pre hook example. This document expects that you have basic knowledge of [Zapp](https://zapp.applicaster.com).
[Zapp Documentation](https://developer-zapp.applicaster.com)

## How to start test env
##### [Pre hook plugin documentation](https://developer-zapp.applicaster.com/ui-builder/ios/PreHooks-ScreenPlugin.html)
###### Preparation

1. In [Zapp](https://zapp.applicaster.com) select your application.
2. Go to section `App Builder`
3. Select your `Layout` configuration
4. Push button `Add Screen` and select `Prehook Example Hook Screen` in pop-up window, change name on your wish.
5. Select a screen where do you want to add prehook (in future `Host` screen).
6. In the right side of screen settings, click on `Before load` section
7. In the list select name of the `Prehook Example Hook Screen` or your name if you changed it. Another option you can select `Prehook Example` that is not `screen plugin` for more information read `Prehooks Plugin` [Documentation](https://developer-zapp.applicaster.com/ui-builder/ios/PreHooks-ScreenPlugin.html).
8. Make sure that your `host` screen was added as part of root navigation.
9. Push `Save` button in top left corner.
10. Push on your app name that will transfer you to `application versions screen`


###### Internal developers
1. Push on `version` button of the app that you want to use in `iOS` tab and copy application `ID` with copy button
2. Clone [Zapp-iOS project](git@github.com:applicaster/Zapp-iOS.git)
3. Use [Explanation](https://github.com/applicaster/Zapp-iOS) how to prepare working env.

###### External developers
1.  Push on `External developer` button of the app that you want to use in `iOS` tab that will download prepared `Zapp-iOS` project for selected app and version.

###### Final Steps for All developes, if `prehook plugin` needed locally for debug

1. Clone [PreHookExample-iOS](https://github.com/applicaster/PreHookExample-iOS) project to your path (in future `PreHookExamplePath`)
2. In `Zapp-iOS` folder open `Podfile` and find:
     `pod 'PrehookExample', '~> version_number'`
      and replace with:
     `pod 'PrehookExample', :path => 'PreHookExamplePath'`
3. In the terminal of `Zapp-iOS` folder push `pod update` and wait
4. Build your app.

After application will be presenting, select `Host` screen, before this screen will be open you must see `Prehook screen`.
![ScreenPluginsGeneral.png](./ReadmeFiles/HookScreen.png)



