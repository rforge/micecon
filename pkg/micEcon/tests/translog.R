library( micEcon )
library( plm )

## preparing data
data( germanFarms )
# output quantity:
germanFarms$qOutput <- germanFarms$vOutput / germanFarms$pOutput
# quantity of variable inputs
germanFarms$qVarInput <- germanFarms$vVarInput / germanFarms$pVarInput
# a time trend to account for technical progress:
germanFarms$time <- c(1:20)
# taking logarithms
germanFarms$qLogOutput   <- log( germanFarms$qOutput ) 
germanFarms$qLogLabor    <- log( germanFarms$qLabor ) 
germanFarms$qLogLand     <- log( germanFarms$land ) 
germanFarms$qLogVarInput <- log( germanFarms$qVarInput ) 
germanFarms$logTime      <- log( germanFarms$time ) 

## testing translogEst
# estimate a translog production function
estResult <- translogEst( "qOutput", c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms )

print( estResult )

summary( estResult )

residuals( estResult )

print.default( estResult )

# estimate the translog production function with a different order of inputs
estResultOrder <- translogEst( yName = "qOutput",
   xNames = c( "qLabor", "qVarInput", "land", "time" ),
   data = germanFarms )
print( estResultOrder )
summary( estResultOrder )
all.equal( residuals( estResult ), residuals( estResultOrder ) )

# estimate the translog production function with a different order of inputs
estResultOrder2 <- translogEst( yName = "qOutput",
   xNames = c( "land", "qVarInput", "qLabor", "time" ),
   data = germanFarms )
print( estResultOrder2 )
summary( estResultOrder2 )
all.equal( residuals( estResult ), residuals( estResultOrder2 ) )

# estimate the translog production function with a different order of inputs
estResultOrder3 <- translogEst( yName = "qOutput",
   xNames = c( "land", "qVarInput", "time", "qLabor" ),
   data = germanFarms )
print( estResultOrder3 )
summary( estResultOrder3 )
all.equal( residuals( estResult ), residuals( estResultOrder3 ) )


## testing translogEst with dataLogged = TRUE
estResultLog <- translogEst( "qLogOutput", 
   xNames = c( "qLogLabor", "qLogLand", "qLogVarInput", "logTime" ),
   data = germanFarms, dataLogged = TRUE )
all.equal( estResult[ -c(1,6,12,13,17) ], estResultLog[ -c(1,6,12,13,17) ] )
all.equal( estResult$fitted, exp( estResultLog$fitted ) )

## testing translogCalc
fitted <- translogCalc( c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, estResult$coef )

all.equal( fitted, estResult$fitted )

## testing translogDeriv
margProducts <- translogDeriv( c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, estResult$coef, estResult$coefCov )
print( margProducts )

margProductsObs <- translogDeriv( c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, estResult$coef, estResult$coefCov, yName = "qOutput" )
print( margProductsObs )

germanFarms$fitted <- fitted
margProductsFitted <- translogDeriv( c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, estResult$coef, estResult$coefCov, yName = "fitted" )
all.equal( margProducts, margProductsFitted )


## testing calculation of elasticities with translogEla
estEla <- translogEla( c( "qLabor", "land", "qVarInput", "time" ), 
   data = germanFarms, coef = coef( estResult ), coefCov = vcov( estResult ) )
print( estEla )
print( attributes( estEla )$variance )
print( attributes( estEla )$stdDev )
estElaMet <- elas( estResult )
all.equal( estEla, estElaMet )
estElaLogMet <- elas( estResultLog )
all.equal( estElaMet, estElaLogMet, check.attributes = FALSE )

## testing translogHessian
# compute the Hessian matrices
hessians <- translogHessian( c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, estResult$coef )
print( hessians )

hessiansObs <- translogHessian( c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, estResult$coef, yName = "qOutput" )
print( hessiansObs )

germanFarms$fitted <- fitted
hessiansFitted <- translogHessian( c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, estResult$coef, yName = "fitted" )
all.equal( hessians, hessiansFitted )

# compute the bordered Hessian matrices
borderedHessians <- translogHessian( c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, estResult$coef, bordered = TRUE )
print( borderedHessians )

borderedHessiansObs <- translogHessian( c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, estResult$coef, yName = "qOutput", bordered = TRUE )
print( borderedHessiansObs )

germanFarms$fitted <- fitted
borderedHessiansFitted <- translogHessian( c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, estResult$coef, yName = "fitted", bordered = TRUE )
all.equal( borderedHessians, borderedHessiansFitted )

## testing translogCheckMono
test <- translogCheckMono( c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, coef( estResult ) )
summary( test )
class( test ) <- NULL
print( test )

test <- translogCheckMono( c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, coef( estResult ), strict = TRUE )
summary( test )
class( test ) <- NULL
print( test )

test <- translogCheckMono( c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, coef( estResult ), increasing = FALSE )
summary( test )
class( test ) <- NULL
print( test )

test <- translogCheckMono( c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, coef( estResult ), increasing = FALSE, strict = TRUE )
summary( test )
class( test ) <- NULL
print( test )


## testing translogCheckCurvature
test <- translogCheckCurvature( c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, coef( estResult ) )
summary( test )
class( test ) <- NULL
print( test )

test <- translogCheckCurvature( c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, coef( estResult ), quasi = TRUE )
summary( test )
class( test ) <- NULL
print( test )

test <- translogCheckCurvature( c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, coef( estResult ), convexity = FALSE )
summary( test )
class( test ) <- NULL
print( test )

test <- translogCheckCurvature( c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, coef( estResult ), convexity = FALSE, quasi = TRUE )
summary( test )
class( test ) <- NULL
print( test )


## testing translogProdFuncMargCost
# generate (artificial) prices
germanFarms$pLand <- 200 + 15 * germanFarms$time
germanFarms$pTime <- 1

# compute the marginal costs of producing the output
margCost <- translogProdFuncMargCost( yNames = "qOutput",
   xNames = c( "qLabor", "land", "qVarInput", "time" ),
   wNames = c( "pLabor", "pLand", "pVarInput", "pTime" ),
   data = germanFarms, coef = coef( estResult ) )
print( margCost )

# compute the marginal costs again with different order of inputs
margCostOrder <- translogProdFuncMargCost( yNames = "qOutput",
   xNames = c( "qLabor", "qVarInput", "land", "time" ),
   wNames = c( "pLabor", "pVarInput", "pLand", "pTime" ),
   data = germanFarms, coef = coef( estResultOrder ) )
all.equal( margCost, margCostOrder )

# compute the marginal costs again with different order of inputs
margCostOrder2 <- translogProdFuncMargCost( yNames = "qOutput",
   xNames = c( "land", "qVarInput", "qLabor", "time" ),
   wNames = c( "pLand", "pVarInput", "pLabor", "pTime" ),
   data = germanFarms, coef = coef( estResultOrder2 ) )
all.equal( margCost, margCostOrder2 )

# compute the marginal costs again with different order of inputs
margCostOrder3 <- translogProdFuncMargCost( yNames = "qOutput",
   xNames = c( "land", "qVarInput", "time", "qLabor" ),
   wNames = c( "pLand", "pVarInput", "pTime", "pLabor" ),
   data = germanFarms, coef = coef( estResultOrder3 ) )
all.equal( margCost, margCostOrder3 )


## testing translogEst with one shifter
germanFarms$tech <- exp( germanFarms$time )
estResultShifter <- translogEst( "qOutput",
   c( "qLabor", "land", "qVarInput" ),
   shifterNames = "tech", data = germanFarms )
print( estResultShifter )
summary( estResultShifter )
residuals( estResultShifter )
print.default( estResultShifter )
# with dataLogged = TRUE
estResultShifterLog <- translogEst( "qLogOutput", 
   xNames = c( "qLogLabor", "qLogLand", "qLogVarInput" ),
   data = germanFarms, shifterNames = "time", dataLogged = TRUE )
all.equal( estResultShifter[ -c(1,6,12,13,14,18) ],
   estResultShifterLog[ -c(1,6,12,13,14,18) ] )
all.equal( estResultShifter$fitted, exp( estResultShifterLog$fitted ) )
# testing translogCalc
fitted <- translogCalc( c( "qLabor", "land", "qVarInput" ),
   shifterNames = "tech", data = germanFarms, coef = estResultShifter$coef )
all.equal( fitted, estResultShifter$fitted )
# testing calculation of elasticities with translogEla
estElaShifter <- translogEla( c( "qLabor", "land", "qVarInput" ), 
   data = germanFarms, coef = coef( estResultShifter ), 
   coefCov = vcov( estResultShifter ) )
print( estElaShifter )
print( attributes( estElaShifter )$variance )
print( attributes( estElaShifter )$stdDev )
estElaShifterMet <- elas( estResultShifter )
all.equal( estElaShifter, estElaShifterMet )
estElaShifterLogMet <- elas( estResultShifterLog )
all.equal( estElaShifterMet, estElaShifterLogMet, check.attributes = FALSE )

## testing translogEst with two shifters
germanFarms$techSq <- exp( germanFarms$time^2 )
estResultShifter2 <- translogEst( "qOutput",
   c( "qLabor", "land", "qVarInput" ),
   shifterNames = c( "tech", "techSq" ), data = germanFarms )
print( estResultShifter2 )
summary( estResultShifter2 )
residuals( estResultShifter2 )
print.default( estResultShifter2 )
# testing translogCalc
fitted <- translogCalc( c( "qLabor", "land", "qVarInput" ),
   shifterNames = c( "tech", "techSq" ), data = germanFarms, 
   coef = estResultShifter2$coef )
all.equal( fitted, estResultShifter2$fitted )

## testing translogEst with a logical variable as shifter
germanFarms$reUnif <- germanFarms$time >= 16
estResultShifterLogi <- translogEst( "qOutput",
   c( "qLabor", "land", "qVarInput" ),
   shifterNames = "reUnif", data = germanFarms )
print( estResultShifterLogi )
summary( estResultShifterLogi )
residuals( estResultShifterLogi )
print.default( estResultShifterLogi )
# with dataLogged = TRUE
estResultShifterLogiLog <- translogEst( "qLogOutput", 
   xNames = c( "qLogLabor", "qLogLand", "qLogVarInput" ),
   data = germanFarms, shifterNames = "reUnif", dataLogged = TRUE )
all.equal( estResultShifterLogi[ -c(1,6,12,13,18) ],
   estResultShifterLogiLog[ -c(1,6,12,13,18) ] )
all.equal( estResultShifterLogi$fitted, exp( estResultShifterLogiLog$fitted ) )
# testing translogCalc
fitted <- translogCalc( c( "qLabor", "land", "qVarInput" ),
   shifterNames = c( "reUnif" ), data = germanFarms, 
   coef = estResultShifterLogi$coef )
all.equal( fitted, estResultShifterLogi$fitted )

## testing translogEst with a factor as shifter
germanFarms$decade <- as.factor( c( rep( "70s", 5 ), rep( "80s", 10 ), 
   rep( "90s", 5 ) ) )
estResultShifterFac <- translogEst( "qOutput",
   c( "qLabor", "land", "qVarInput" ),
   shifterNames = "decade", data = germanFarms )
print( estResultShifterFac )
summary( estResultShifterFac )
residuals( estResultShifterFac )
print.default( estResultShifterFac )
# with dataLogged = TRUE
estResultShifterFacLog <- translogEst( "qLogOutput", 
   xNames = c( "qLogLabor", "qLogLand", "qLogVarInput" ),
   data = germanFarms, shifterNames = "decade", dataLogged = TRUE )
all.equal( estResultShifterFac[ -c(1,6,12,13,18) ],
   estResultShifterFacLog[ -c(1,6,12,13,18) ] )
all.equal( estResultShifterFac$fitted, exp( estResultShifterFacLog$fitted ) )
# testing translogCalc
fitted <- translogCalc( c( "qLabor", "land", "qVarInput" ),
   shifterNames = c( "decade" ), data = germanFarms, 
   coef = estResultShifterFac$coef )
all.equal( fitted, estResultShifterFac$fitted )

## testing translogEst with some shifters and one is logical
estResultShifterLogi2 <- translogEst( "qOutput",
   c( "qLabor", "land", "qVarInput" ),
   shifterNames = c( "tech", "reUnif" ), data = germanFarms )
print( estResultShifterLogi2 )
summary( estResultShifterLogi2 )
residuals( estResultShifterLogi2 )
print.default( estResultShifterLogi2 )
# testing translogCalc
fitted <- translogCalc( c( "qLabor", "land", "qVarInput" ),
   shifterNames = c( "tech", "reUnif" ), data = germanFarms, 
   coef = estResultShifterLogi2$coef )
all.equal( fitted, estResultShifterLogi2$fitted )

## testing translogEst with some shifters and one is a factor
estResultShifterFac2 <- translogEst( "qOutput",
   c( "qLabor", "land", "qVarInput" ),
   shifterNames = c( "tech", "decade" ), data = germanFarms )
print( estResultShifterFac2 )
summary( estResultShifterFac2 )
residuals( estResultShifterFac2 )
print.default( estResultShifterFac2 )
# testing translogCalc
fitted <- translogCalc( c( "qLabor", "land", "qVarInput" ),
   shifterNames = c( "tech", "decade" ), data = germanFarms, 
   coef = estResultShifterFac2$coef )
all.equal( fitted, estResultShifterFac2$fitted )

## estimate with further argument passed to lm()
estResult2 <- translogEst( yName = "qOutput",
   xNames = c( "qLabor", "land", "qVarInput", "time" ),
   germanFarms, x = TRUE, y = TRUE )
print( estResult2 )
summary( estResult2 )
print.default( estResult2 )

## panel data
data( "GrunfeldGreene", package = "systemfit" )
ggData <- plm.data( GrunfeldGreene, c( "firm", "year" ) )
ggData$logInvest <- log( ggData$invest )
ggData$logValue <- log( ggData$value )
ggData$logCapital <- log( ggData$capital )
# fixed effects
ggResult <- translogEst( "invest", c( "value", "capital" ), ggData )
print( ggResult )
print.default( ggResult )
# with dataLogged = TRUE
ggResultLog <- translogEst( "logInvest", 
   xNames = c( "logValue", "logCapital" ),
   data = ggData, dataLogged = TRUE )
all.equal( ggResult[ -c(1,6,10,11,15) ], ggResultLog[ -c(1,6,10,11,15) ] )
all.equal( ggResult$fitted, exp( ggResultLog$fitted ) )
# random effects
ggResultRan <- translogEst( "invest", c( "value", "capital" ), ggData,
   model = "random", random.method = "amemiya" )
print( ggResultRan )
print.default( ggResultRan )
# with dataLogged = TRUE
ggResultRanLog <- translogEst( "logInvest", 
   xNames = c( "logValue", "logCapital" ),
   data = ggData, dataLogged = TRUE,
   model = "random", random.method = "amemiya" )
all.equal( ggResultRan[ -c(1,6,10,11,15) ], ggResultRanLog[ -c(1,6,10,11,15) ] )
all.equal( ggResultRan$fitted, exp( ggResultRanLog$fitted ) )

## testing translogEla with panel data
# fixed effects
ggEla <- translogEla( c( "value", "capital" ), 
   data = ggData, coef = coef( ggResult ), 
   coefCov = vcov( ggResult ) )
print( ggEla )
print( attributes( ggEla )$variance )
print( attributes( ggEla )$stdDev )
ggElaMet <- elas( ggResult )
all.equal( ggEla, ggElaMet )
ggElaLogMet <- elas( ggResultLog )
all.equal( ggElaMet, ggElaLogMet, check.attributes = FALSE )
# random effects
ggElaRan <- translogEla( c( "value", "capital" ), 
   data = ggData, coef = coef( ggResultRan ),
   coefCov = vcov( ggResultRan ) )
print( ggElaRan )
print( attributes( ggElaRan )$variance )
print( attributes( ggElaRan )$stdDev )
ggElaRanMet <- elas( ggResultRan )
all.equal( ggElaRan, ggElaRanMet )
ggElaRanLogMet <- elas( ggResultRanLog )
all.equal( ggElaRanMet, ggElaRanLogMet, check.attributes = FALSE )

## panel data with a shifter
ggData$yearInt <- as.integer( as.character( ggData$year ) )
ggData$tech <- exp( ggData$yearInt - min( ggData$yearInt ) )
# fixed effects
ggResShifter <- translogEst( "invest", c( "value", "capital" ), ggData,
   shifterNames = "tech" )
print( ggResShifter )
print.default( ggResShifter )
# random effects
ggResShifterRan <- translogEst( "invest", c( "value", "capital" ), ggData,
   shifterNames = "tech", model = "random", random.method = "amemiya" )
print( ggResShifterRan )
print.default( ggResShifterRan )

## panel data with a logical variable as shifter
ggData$war <- ggData$yearInt >= 1939 & ggData$yearInt <= 1945
# fixed effects
ggResShifterLogi <- translogEst( "invest", c( "value", "capital" ), ggData,
   shifterNames = "war" )
print( ggResShifterLogi )
print.default( ggResShifterLogi )
# random effects
ggResShifterLogiRan <- translogEst( "invest", c( "value", "capital" ), ggData,
   shifterNames = "war", model = "random", random.method = "amemiya" )
print( ggResShifterLogiRan )
print.default( ggResShifterLogiRan )

## panel data with a factor as shifter
ggData$decade <- as.factor( ifelse( ggData$yearInt <= 1939, "30s",
   ifelse( ggData$yearInt <= 1949, "40s", "50s" ) ) )
# fixed effects
ggResShifterFac <- translogEst( "invest", c( "value", "capital" ), ggData,
   shifterNames = "decade" )
print( ggResShifterFac )
print.default( ggResShifterFac )
# random effects
ggResShifterFacRan <- translogEst( "invest", c( "value", "capital" ), ggData,
   shifterNames = "decade", model = "random", random.method = "amemiya" )
print( ggResShifterFacRan )
print.default( ggResShifterFacRan )


## translog ray production function
# quantity of crop outputs
germanFarms$qCrop <- germanFarms$vCrop / germanFarms$pOutput
# quantity of animal outputs
germanFarms$qAnimal <- germanFarms$vAnimal / germanFarms$pOutput

# estimate a translog ray production function
estResultRay <- translogRayEst( yNames = c( "qCrop", "qAnimal" ),
   xNames = c( "qLabor", "land", "qVarInput" ),
   data = germanFarms )
print( estResultRay )
summary( estResultRay )
print.default( estResultRay )

# different order of outputs
estResultRay2 <- translogRayEst( yNames = c( "qAnimal", "qCrop" ),
   xNames = c( "qLabor", "land", "qVarInput" ),
   data = germanFarms )
print( estResultRay2 )
summary( estResultRay2 )
all.equal( abs( coef( estResultRay2 )[ 6:15 ] ),
   abs( coef( estResultRay )[ 6:15 ] ) )

# different order of inputs
estResultRay3 <- translogRayEst( yNames = c( "qCrop", "qAnimal" ),
   xNames = c( "qVarInput", "qLabor", "land" ),
   data = germanFarms )
print( estResultRay3 )
summary( estResultRay3 )
all.equal( coef( estResultRay ), coef( estResultRay3 )[
   c( 1, 3, 4, 2, 5, 10, 11, 7, 12, 13, 8, 14, 6, 9, 15 ) ],
   check.attributes = FALSE )


## testing translogRayDeriv
tlRayDeriv <- translogRayDeriv( yNames = c( "qCrop", "qAnimal" ),
   xNames = c( "qLabor", "land", "qVarInput" ),
   data = germanFarms, coef = coef( estResultRay ) )
print( tlRayDeriv )

tlRayDeriv2 <- translogRayDeriv( yNames = c( "qAnimal", "qCrop" ),
   xNames = c( "qLabor", "land", "qVarInput" ),
   data = germanFarms, coef = coef( estResultRay2 ) )
all.equal( tlRayDeriv, tlRayDeriv2[ , c( 1:3, 5, 4 ) ] )

tlRayDeriv3 <- translogRayDeriv( yNames = c( "qCrop", "qAnimal" ),
   xNames = c( "qVarInput", "qLabor", "land" ),
   data = germanFarms, coef = coef( estResultRay3 ) )
all.equal( tlRayDeriv, tlRayDeriv3[ , c( 2, 3, 1, 4, 5 ) ] )


## testing translogProdFuncMargCost with a ray function
# compute the marginal costs of producing the output
margCostRay <- translogProdFuncMargCost( yNames = c( "qCrop", "qAnimal" ),
   xNames = c( "qLabor", "land", "qVarInput" ),
   wNames = c( "pLabor", "pLand", "pVarInput" ),
   data = germanFarms, coef = coef( estResultRay ) )
print( margCostRay )

margCostRay2 <- translogProdFuncMargCost( yNames = c( "qAnimal", "qCrop" ),
   xNames = c( "qLabor", "land", "qVarInput" ),
   wNames = c( "pLabor", "pLand", "pVarInput" ),
   data = germanFarms, coef = coef( estResultRay2 ) )
all.equal( margCostRay, margCostRay2[ , c( 2:1 ) ] )

margCostRay3 <- translogProdFuncMargCost( yNames = c( "qCrop", "qAnimal" ),
   xNames = c( "qVarInput", "qLabor", "land" ),
   wNames = c( "pVarInput", "pLabor", "pLand" ),
   data = germanFarms, coef = coef( estResultRay3 ) )
all.equal( margCostRay, margCostRay3 )