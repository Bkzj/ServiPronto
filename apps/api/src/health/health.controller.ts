import { Controller, Get, ServiceUnavailableException } from '@nestjs/common';
import { ApiOkResponse, ApiOperation, ApiServiceUnavailableResponse, ApiTags } from '@nestjs/swagger';
import { PrismaService } from '../database/prisma.service.js';

type HealthStatus = {
  status: 'ok' | 'unavailable';
  service: 'api' | 'database';
  timestamp: string;
};

@ApiTags('health')
@Controller('health')
export class HealthController {
  constructor(private readonly prisma: PrismaService) {}

  @Get('live')
  @ApiOperation({ summary: 'Confirma que el proceso de API responde' })
  @ApiOkResponse({ description: 'Proceso disponible' })
  live(): HealthStatus {
    return { status: 'ok', service: 'api', timestamp: new Date().toISOString() };
  }

  @Get('ready')
  @ApiOperation({ summary: 'Confirma que PostgreSQL responde' })
  @ApiOkResponse({ description: 'API y base listas' })
  @ApiServiceUnavailableResponse({ description: 'PostgreSQL no disponible' })
  async ready(): Promise<HealthStatus> {
    try {
      await this.prisma.$queryRaw`SELECT 1`;
      return { status: 'ok', service: 'database', timestamp: new Date().toISOString() };
    } catch {
      throw new ServiceUnavailableException({
        status: 'unavailable', service: 'database', timestamp: new Date().toISOString(),
      } satisfies HealthStatus);
    }
  }
}
