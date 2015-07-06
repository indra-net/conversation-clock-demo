_ = require 'lodash'

getAverageVolume = (array) -> 
    return _.sum(array) / array.length

module.exports = getAverageVolume
