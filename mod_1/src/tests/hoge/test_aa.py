import unittest

import hoge.aa as tested_mod


class TestAdd2(unittest.TestCase):
    def __init__(self, *args, **kwargs):
        self.tested_func = tested_mod.add_2

        super().__init__(*args, **kwargs)

    def test_pass_3(self):
        """引数3を渡した時の動作をテスト."""
        actual = self.tested_func(3)
        expected = 5

        # self.fail("Check this test runs.")
        self.assertEqual(actual, expected)


class TestAdd3(unittest.TestCase):
    def __init__(self, *args, **kwargs):
        self.tested_func = tested_mod.add_3

        super().__init__(*args, **kwargs)

    def test_pass_3(self):
        """引数3を渡した時の動作をテスト."""
        actual = self.tested_func(3)
        expected = 6

        # raise Exception("AAAAAAAA")
        # self.fail("Check this test runs.")
        self.assertEqual(actual, expected)
