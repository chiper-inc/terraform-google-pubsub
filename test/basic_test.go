package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestBasicExample(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic",
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.WorkspaceSelectOrNew(t, terraformOptions, "dev")
	terraform.InitAndApply(t, terraformOptions)

	name := terraform.Output(t, terraformOptions, "name")
	dql := terraform.OutputMap(t, terraformOptions, "dlqs")

	assert.Equal(t, "example-basic-topic", name)
	assert.Equal(t, "projects/chiper-development/topics/example-basic-topic-dlq", dql["example-basic-topic"])

}
