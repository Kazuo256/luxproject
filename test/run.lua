
package.path = package.path..";./lib/?.lua"

require 'lux.test'

lux.test.unit "lux.oo.prototype"
lux.test.unit "lux.datastruct.List"
lux.test.unit "lux.macro.Processor"
lux.test.unit "lux.functional"

