#include <cstdint>
#include <iostream>
#include <string>

#include "../include/image_processing.hpp"
#include "../include/marching_cubes.hpp"
#include "../include/timer.hpp"

#define X 200
#define Y 100
#define Z 100

int main() {
  // MarchingCubes mc = MarchingCubes(X, Y, Z, 1.0);
  ImageProcessing ip = ImageProcessing(1000, 600, 3, 10);

  for (int i = 0; i < 1; ++i) {
    std::cout << "===========================\n";
    {
      Timer t("Set P", TimeUnit::TIME_UNIT_μS);
      ip.set_p(3.5f);
    }

    {
      Timer t("Set raw", TimeUnit::TIME_UNIT_μS);
      ip.fill_raw_pixels(100.25f);
    }

    {
      Timer t("update mask", TimeUnit::TIME_UNIT_μS);
      ip.update_is_valid(0.0f);
    }

    {
      Timer t("Evaluating Pixels", TimeUnit::TIME_UNIT_μS);
      ip.evaluate_pixels();
    }

    {
      Timer t("Calculate Errors", TimeUnit::TIME_UNIT_μS);
      float er = ip.evaluate_error();
      std::cout << "err = " << er / (100 * 600) << std::endl;
    }

    {
      Timer t("Next Iterate", TimeUnit::TIME_UNIT_μS);
      for (uint32_t i = 0; i < 100; ++i) {
        // ip.savefile("file" + std::to_string(i) + ".m");
        ip.evaluate_pixels();
        ip.evaluate_error();
        // std::cout << er << '\n';
        ip.next_iteration(1.0f);
      }
    }

    {
      Timer t("Calculate Errors", TimeUnit::TIME_UNIT_μS);
      float er = ip.evaluate_error();
      std::cout << "err = " << er / (100 * 600) << std::endl;
      // std::cout << "err = " << er << std::endl;
    }

    // ip.print();
  }
}
