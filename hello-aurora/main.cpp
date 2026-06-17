/** hello-aurora
 *
 *  Minimal Aurora starter project.
 *  Initialises the hardware and loops, processing all controls.
 */
#include "aurora.h"

using namespace daisy;
using namespace aurora;

/** Global hardware object */
Hardware hw;

int main(void)
{
    /** Initialise the hardware */
    hw.Init();

    /** Infinite loop */
    while (1)
    {
        hw.ProcessAllControls();
    }
}
