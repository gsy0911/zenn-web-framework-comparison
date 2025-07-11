import { Controller, Get } from '@nestjs/common';

@Controller()
export class AppController {
  @Get('user')
  getUser(): { status: string } {
    return { status: 'success' };
  }

  @Get('healthcheck')
  healthcheck(): { status: string } {
    return { status: 'success' };
  }
}