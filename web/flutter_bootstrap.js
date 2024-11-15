{{flutter_js}}
{{flutter_build_config}}

// Customize the app initialization process
_flutter.loader.load({
   serviceWorkerSettings: {
      serviceWorkerVersion: {{flutter_service_worker_version}},
   },
    onEntrypointLoaded: async function(engineInitializer) {
        const appRunner = await engineInitializer.initializeEngine({
            useColorEmoji: true
        });

        await appRunner.runApp();
    }

});