(function () {
    var stateConfig = angular.module('stateConfig', []);
    stateConfig.config(

        function ($stateProvider, $urlRouterProvider, $httpProvider) {

            $urlRouterProvider.otherwise("/calllist");
            $stateProvider.state('calllist', {
                url: "/calllist",
                templateUrl: "views/calllist.html",
                data: {
                    pageTitle: 'ServiceNow Call List'
                }
            })
        })
})();