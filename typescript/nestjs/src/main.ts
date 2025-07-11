import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // Get PREFIX from environment variable, similar to Python implementations
  const prefix = process.env.PREFIX || '';
  
  if (prefix) {
    app.setGlobalPrefix(prefix);
  }
  
  // Enable CORS for cross-origin requests
  app.enableCors();
  
  await app.listen(8080, '0.0.0.0');
}

bootstrap();