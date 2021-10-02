import inspect
import logging
import unittest

from tests import (
    test_hi,
)

# Disable logging while unittest.
logging.disable()

TEST_CLASSES = {
    test_hi.TestAdd2,
}

def set_cases_of_classes(suite):
    """Unittest classの全testメソッドをsuiteに登録する."""
    for test_class in TEST_CLASSES:
        # Execute all test method of the class
        suite.addTest(unittest.makeSuite(test_class))

def get_suite():
    suite = unittest.TestSuite()
    set_cases_of_classes(suite)

    return suite


if __name__ == "__main__":
    runner = unittest.TextTestRunner()
    runner.run(get_suite())
