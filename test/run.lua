
package.path = package.path..";./lib/?.lua"

require 'lux.test'

lux.test.unit "lux.object"
lux.test.unit "lux.list"
lux.test.unit "lux.functional"

