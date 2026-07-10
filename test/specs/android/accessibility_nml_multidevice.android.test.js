import { Eyes, ClassicRunner, Target, BatchInfo, Configuration } from '@applitools/eyes-webdriverio';

describe('Accessibility Android NML - BrowserStack', () => {
  let eyes, runner, config;

  before(async () => {
    runner = new ClassicRunner();
    eyes = new Eyes(runner);
    eyes.setLogHandler({ type: 'file', filename: './logs/eyes_browserstack.log' });

    config = new Configuration();
    config.setApiKey(process.env.APPLITOOLS_API_KEY);
    config.setUseDom(true);
    config.setSendDom(true);
    config.setBatch(new BatchInfo('JS BrowserStack | NML | Android Accessibility | Multi Device'));
    config.addMultiDeviceTarget('Galaxy S25', 'Galaxy S25 Ultra', 'Pixel 9');
    eyes.setConfiguration(config);

    await eyes.open(browser, 'BrowserStack Android Accessibility App', 'Android Accessibility Validation');
    console.log('Eyes open');
  });

  after(async () => {
    await eyes.abortIfNotClosed();
  });

  it('validates the Accessibility app main screen', async () => {
    await eyes.check('Main Screen', Target.window());
    console.log('Checked: Main Screen');

    await eyes.check('Main Screen | Fully', Target.window().fully());

    await eyes.close(false);
    console.log('Eyes closed');
  });
});
