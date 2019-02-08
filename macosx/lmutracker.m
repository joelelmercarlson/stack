// lmutracker.mm
// clang -o lmutracker lmutracker.m -framework IOKit -framework CoreFoundation
//
// doesnt work on MacBook Pro, yet
#include <mach/mach.h>
#include <IOKit/IOKitLib.h>
#include <CoreFoundation/CoreFoundation.h>

static double updateInterval = 0.1;
static io_connect_t dataPort = 0;

void updateTimerCallBack(CFRunLoopTimerRef timer, void *info) {
  kern_return_t kr;
  uint32_t      outputs = 2;
  uint64_t      values[outputs];

  kr = IOConnectCallMethod(dataPort
                           , 0
                           , nil
                           , 0
                           , nil
                           , 0
                           , values
                           , &outputs
                           , nil
                           , 0);
  if (kr == KERN_SUCCESS) {
    printf("%8lld", values[0]);
    exit(0);
  }

  if (kr == kIOReturnBusy) {
    return;
  }

  mach_error("IOKit: ", kr);
  exit(kr);

}

int main (void) {
  kern_return_t     kr;
  io_service_t      serviceObject;
  CFRunLoopTimerRef updateTimer;

  serviceObject = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleLMUController"));
  if (!serviceObject) {
    fprintf(stderr, "failed to find ambient light sensors\n");
    exit(1);
  }

  kr = IOServiceOpen(serviceObject
                     , mach_task_self()
                     , 0
                     , &dataPort);
  IOObjectRelease(serviceObject);
  if (kr != KERN_SUCCESS) {
    mach_error("IOServiceOpen:", kr);
    exit(kr);
  }

  setbuf(stdout, NULL);

  updateTimer = CFRunLoopTimerCreate(kCFAllocatorDefault
                                     , CFAbsoluteTimeGetCurrent() + updateInterval
                                     , updateInterval
                                     , 0
                                     , 0
                                     , updateTimerCallBack
                                     , NULL);
  CFRunLoopAddTimer(CFRunLoopGetCurrent()
                    , updateTimer
                    , kCFRunLoopDefaultMode);
  CFRunLoopRun();
  
  exit(0);
}
