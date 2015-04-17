(function () {
    var listControllers = angular.module('listControllers', []);

    listControllers.controller('ListCtrl', ['$scope', '$http', '$interval', function ($scope, $http, $interval) {

        $scope.getList = function () {
            $http.get("/phoneList").success(function (response) {
                $scope.result = response.result;
            }).error(function (response) {
                console.log('Error getting list of phone numbers');
            });
        }
        $scope.getList();
        $interval($scope.getList, 5000);
    }]);
})();
