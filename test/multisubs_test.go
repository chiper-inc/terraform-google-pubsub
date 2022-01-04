package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestMultiSubsExample(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/multi-subs",
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.WorkspaceSelectOrNew(t, terraformOptions, "dev")
	terraform.InitAndApply(t, terraformOptions)

	name := terraform.Output(t, terraformOptions, "name")
	dql := terraform.OutputMap(t, terraformOptions, "dlqs")

	assert.Equal(t, "example-multi-topic", name)
	assert.Equal(t, "projects/chiper-development/topics/example-multi-topic-one-dlq", dql["example-multi-topic-one"])
	assert.Equal(t, "projects/chiper-development/topics/example-multi-topic-two-dlq", dql["example-multi-topic-two"])

}
