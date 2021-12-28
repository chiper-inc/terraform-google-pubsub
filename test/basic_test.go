package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestBasicExample(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic",
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.WorkspaceSelectOrNew(t, terraformOptions, "chiper-poc")
	terraform.InitAndApply(t, terraformOptions)

}
