import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { AdminAuthGuard } from '../auth/admin-auth.guard.js';
import { moduleRegistry } from '../modules/module-registry.js';

@ApiTags('admin')
@ApiBearerAuth()
@UseGuards(AdminAuthGuard)
@Controller('admin')
export class AdminController {
  @Get('modules')
  @ApiOkResponse({ description: 'Fronteras modulares y estado real' })
  modules() {
    return { modules: moduleRegistry };
  }
}
