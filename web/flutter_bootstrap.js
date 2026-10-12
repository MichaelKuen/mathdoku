{{flutter_js}}
{{flutter_build_config}}

window.addEventListener('load', function () {
  _flutter.loader.load({
    onEntrypointLoaded: async function (engineInitializer) {
      let appRunner = await engineInitializer.initializeEngine({
        hostElement: document.querySelector('#game-embed'),
      });
      await appRunner.runApp();
    }
  });
});
