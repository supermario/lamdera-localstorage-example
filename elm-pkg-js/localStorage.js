exports.init = async function(app) {
  app.ports.setStorage.subscribe(
    function(text) {
      localStorage.setItem('appStorage', text)
     }
  )
  app.ports.getStorage.subscribe(
    function() {
        console.log('getStorage called')
      var storedData = localStorage.getItem('appStorage');
      app.ports.load.send(storedData ? storedData : "null")
    }
  )
}
