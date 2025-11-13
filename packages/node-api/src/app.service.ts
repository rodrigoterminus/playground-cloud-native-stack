import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): object {
    return {
      message: 'Hello World',
      timestamp: new Date().toISOString(),
      service: 'node-api'
    };
  }

  getHealth(): object {
    /**
     * Liveness probe endpoint.
     * Returns healthy if the application process is running and responsive.
     * Does not check external dependencies.
     */
    return {
      status: 'healthy',
      timestamp: new Date().toISOString(),
      uptime: process.uptime()
    };
  }

  getReady(): object {
    /**
     * Readiness probe endpoint.
     * Returns ready if the application is ready to handle traffic.
     * In production, this would check external dependencies like databases.
     */
    // In a real app, you'd check:
    // - Database connectivity
    // - Cache availability
    // - Required external services
    return {
      status: 'ready',
      timestamp: new Date().toISOString(),
      checks: {
        // database: 'ok',
        // cache: 'ok'
      }
    };
  }
}
