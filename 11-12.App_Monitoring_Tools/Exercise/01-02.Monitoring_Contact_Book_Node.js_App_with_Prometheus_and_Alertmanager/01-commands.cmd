echo off

::Install pacges and run node taskboard app
node --version
npm install
npm run start

::Install Prometheus node package
npm install prom-client

::Run Prometheus
"C:\Program Files\Prometheus-2.49.1\prometheus.exe" --config.file "prometheus-contactbook.yml"

::Alterations made to the mvc-controller.js file
@REM const register = new client.Registry();

@REM client.collectDefaultMetrics({
@REM   app: "node-application-monitoring-app",
@REM   prefix: "node_",
@REM   timeout: 10000,
@REM   gcDurationBuckets: [0.001, 0.01, 0.1, 1 , 2, 5],
@REM   register
@REM });

@REM const httpRequestTimer = new client.Histogram({
@REM   name: 'http_request_duration_seconds',
@REM   help: 'Duration of HTTP request in seconds',
@REM   labelNames: ['method', 'route', 'code'],
@REM   buckets: [0.01, 0.03, 0.05, 0.07, 0.1, 0.3, 0.5, 0.7, 1]
@REM });

@REM register.registerMetric(httpRequestTimer);

@REM function setup(app, data) {
@REM   app.get('/', function(req, res) {
@REM     const end = httpRequestTimer.startTimer();
@REM     const route = req.route.path;

@REM     let contacts = data.getContacts();
@REM     let model = { contacts };
@REM     res.render('home', model);

@REM     end({ route, code: res.statusCode, method: req.method });    
@REM   });

@REM   app.get('/metrics', async (req, res) => {
@REM     const end = httpRequestTimer.startTimer();
@REM     const route = req.route.path;

@REM     res.setHeader('Content-Type', register.contentType);
@REM     res.send(await register.metrics());

@REM     end({ route, code: res.statusCode, method: req.method });
@REM   });

@REM   app.get('/contacts', function(req, res) {
@REM     const end = httpRequestTimer.startTimer();
@REM     const route = req.route.path;

@REM     let contacts = data.getContacts();
@REM     let model = { contacts };
@REM     res.render('contacts', model);

@REM     end({ route, code: res.statusCode, method: req.method });
@REM   });
