
package.path = package.path..";./lib/?.lua"

require 'lux.test'

lux.test.unit "lux.Object"
lux.test.unit "lux.List"
lux.test.unit "lux.macro.Processor"
lux.test.unit "lux.functional"

